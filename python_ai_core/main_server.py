import cv2
import dlib
import asyncio
import websockets
import json
import numpy as np
import time  # Import time for the delay
from scipy.spatial import distance as dist
# --- FIX 1: Corrected import ---
from fer.fer import FER  # The class is 'Fer' from the 'fer' module

# --- 1. Constants & Thresholds ---
EAR_THRESHOLD = 0.25
EAR_CONSEC_FRAMES = 15  # Frames to trigger drowsiness
FER_CONSEC_FRAMES = 5  # Frames to trigger agitation
STATE_COOLDOWN_PERIOD = 5  # Seconds an alert will stay active

HOST = '0.0.0.0'
PORT = 8765

# --- 2. Dlib & FER Initialization ---
print("Loading Dlib facial landmark predictor...")
DLIB_PREDICTOR_PATH = 'shape_predictor_68_face_landmarks.dat'
detector = dlib.get_frontal_face_detector()
predictor = dlib.shape_predictor(DLIB_PREDICTOR_PATH)
(lStart, lEnd) = (42, 48)
(rStart, rEnd) = (36, 42)

print("Loading Facial Emotion Recognition (FER) model...")
# --- FIX 2: Corrected class name ---
emotion_detector = FER()  # The class is 'Fer', not 'FER'
print("Models loaded. Starting video capture...")


# --- 3. Drowsiness Helper Function (EAR) ---
def eye_aspect_ratio(eye):
    A = dist.euclidean(eye[1], eye[5])
    B = dist.euclidean(eye[2], eye[4])
    C = dist.euclidean(eye[0], eye[3])
    ear = (A + B) / (2.0 * C)
    return ear


# --- 4. WebSocket Server Logic ---
CONNECTED_CLIENTS = set()


async def broadcast_alert(alert_data):
    if CONNECTED_CLIENTS:
        message = json.dumps(alert_data)
        # Use asyncio.wait to send to all clients concurrently
        await asyncio.wait([client.send(message) for client in CONNECTED_CLIENTS])


async def ws_handler(websocket, path):
    print(f"Flutter app connected from {websocket.remote_address}")
    CONNECTED_CLIENTS.add(websocket)
    try:
        # Keep connection open
        await websocket.wait_closed()
    finally:
        print(f"Flutter app disconnected from {websocket.remote_address}")
        CONNECTED_CLIENTS.remove(websocket)


# --- 5. AI Processing Function (to run in a thread) ---
def process_frame(frame, gray):
    """
    This is a blocking (synchronous) function that runs all AI models.
    It will be called in a separate thread.
    """
    is_drowsy_frame = False
    is_agitated_frame = False

    # 1. Dlib Drowsiness Detection
    rects = detector(gray, 0)
    if rects:
        rect = rects[0]  # Assume one driver
        shape = predictor(gray, rect)
        shape = np.array([[p.x, p.y] for p in shape.parts()])

        leftEye = shape[lStart:lEnd]
        rightEye = shape[rStart:rEnd]
        leftEAR = eye_aspect_ratio(leftEye)
        rightEAR = eye_aspect_ratio(rightEye)

        ear = (leftEAR + rightEAR) / 2.0

        if ear < EAR_THRESHOLD:
            is_drowsy_frame = True

        # 2. FER Agitation Detection
        # FER works better on the original color frame
        try:
            emotion_result = emotion_detector.detect_emotions(frame)
            if emotion_result:
                # Get the 'angry' score from the emotions dict
                top_emotion = emotion_result[0]['emotions']['angry']
                if top_emotion > 0.7:  # 70% confidence of anger
                    is_agitated_frame = True
        except Exception as e:
            pass  # FER can fail on some frames (e.g., no face)

    return is_drowsy_frame, is_agitated_frame


# --- 6. Main AI "Fusion" Core (Async) ---
async def ai_core_loop():
    """The main 'Sense -> Think -> Act' loop."""

    ear_counter = 0
    fer_counter = 0
    driver_state = "SAFE"
    last_state = "SAFE"
    last_alert_time = 0  # Time the last alert was triggered

    cap = cv2.VideoCapture(0)
    if not cap.isOpened():
        print("Error: Cannot open webcam.")
        return

    print("AI Core running... looking for driver.")
    while True:
        # --- SENSE ---
        ret, frame = cap.read()
        if not ret:
            break

        # Prep data for AI model (processing on a smaller frame is faster)
        small_frame = cv2.resize(frame, (0, 0), fx=0.5, fy=0.5)
        gray = cv2.cvtColor(small_frame, cv2.COLOR_BGR2GRAY)

        # --- THINK (Non-Blocking) ---
        # Run the heavy AI processing in a separate thread
        # so it doesn't block the asyncio event loop
        try:
            is_drowsy, is_agitated = await asyncio.to_thread(
                process_frame, frame, gray
            )
        except Exception as e:
            print(f"AI processing error: {e}")
            continue

        # --- FUSION LOGIC (with Cooldown) ---
        
        # Update counters based on AI thread results
        if is_drowsy:
            ear_counter += 1
        else:
            ear_counter = 0  # Reset if eyes are open

        if is_agitated:
            fer_counter += 1
        else:
            fer_counter = 0  # Reset if not angry

        # 1. Determine the *current* frame's state (Priority: Drowsy > Agitated > Safe)
        current_frame_state = "SAFE"
        if ear_counter >= EAR_CONSEC_FRAMES:
            current_frame_state = "DROWSY"
        elif fer_counter >= FER_CONSEC_FRAMES:
            current_frame_state = "AGITATED"

        # 2. Apply cooldown logic
        if current_frame_state != "SAFE":
            # If an alert is active, set it immediately and update the timestamp
            driver_state = current_frame_state
            last_alert_time = time.time()
        else:
            # If the frame is "SAFE", check if the cooldown period has passed
            if time.time() - last_alert_time > STATE_COOLDOWN_PERIOD:
                driver_state = "SAFE"
            # If cooldown hasn't passed, driver_state remains "DROWSY" or "AGITATED"

        # --- ACT (Broadcast only on state change) ---
        if driver_state != last_state:
            intervention = ""
            if driver_state == "DROWSY":
                intervention = "Drowsiness detected. Suggesting rest stop."
            elif driver_state == "AGITATED":
                intervention = "Agitation detected. Initiating calming sequence."
            else:
                intervention = "All clear. Drive safe!"

            print(f"STATE CHANGE: {driver_state}")
            await broadcast_alert({
                "alert": driver_state,
                "intervention": intervention
            })

        last_state = driver_state

        # Yield control back to the event loop
        await asyncio.sleep(0.05)

    cap.release()


# --- 7. Start Server ---
async def main():
    server = await websockets.serve(ws_handler, HOST, PORT)
    print(f"WebSocket server started at ws://{HOST}:{PORT}")

    ai_task = asyncio.create_task(ai_core_loop())

    await asyncio.gather(server.wait_closed(), ai_task)


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("Shutting down server.")