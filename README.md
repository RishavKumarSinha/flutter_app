# Volo: AI-Enhanced Driver Wellness Monitoring

<img width="380" height="830" alt="Screenshot 2025-11-09 191947" src="https://github.com/user-attachments/assets/f4ba273f-b255-4934-9fe6-91b5463f67b5" />


### Our "Empathic Co-pilot" for the Volkswagen i.mobilothon 5.0

[![Python 3.9+](https://img.shields.io/badge/python-3.9+-blue.svg)](https://www.python.org/downloads/)
[![Flutter 3.x](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)
[![OpenCV](https://img.shields.io/badge/OpenCV-4.x-green.svg)](https://opencv.org/)
[![TensorFlow](https://img.shields.io/badge/TensorFlow-2.x-orange.svg)](https://www.tensorflow.org/)

**Team:** Volo
**Team Leader:** Rishav Kumar Sinha 
**Event:** Volkswagen i.mobilothon 5.0 (Student Track)

---

## 1. 🎯 The Problem

Current driver monitoring systems are one-dimensional. They are **reactive**, only responding to drowsiness *after* it's a critical problem. Worse, they are completely **blind to high-stress issues** like road rage or driver anxiety. They also ignore critical environmental context, like elevated CO2 levels in the cabin, which can directly cause fatigue and impaired cognitive function.

## 2. 💡 Our Solution: Volo

**Volo is the industry's first "empathic co-pilot."** It is an AI-powered system designed to create a holistic understanding of the driver's state.

We believe in **prevention over cure**. Our system proves this by validating three distinct components:

1.  **The Volo AI Core (Python):** A real-time computer vision server that uses a standard webcam to analyze facial landmarks (for drowsiness) and emotions (for agitation). It broadcasts alerts via WebSocket.
2.  **Hardware Prototypes (Arduino):** We built and validated two sensor circuits:
    * **MQ3 Alcohol Sensor** for pre-drive compliance checks.
    * **MQ135 Air Quality Sensor** for monitoring CO2 levels.
3.  **The HMI (Flutter App):** A cross-platform mobile app that serves as the Human-Machine Interface. It receives live alerts, displays the driver's real-time status, and sends system notifications.

## 3. ✨ Key Features

* **Real-time Drowsiness Detection:** Uses OpenCV and Dlib to calculate Eye Aspect Ratio (EAR) from the driver's facial landmarks.
* **Stress & Agitation Detection:** Uses a Facial Emotion Recognition (FER) model to detect high-stress states like anger.
* **Pre-Drive Alcohol Lockout:** Our hardware prototype proves the concept of using an MQ3 sensor to prevent ignition if alcohol is detected.
* **Cabin Air Quality Monitoring:** The MQ135 prototype validates monitoring CO2 levels to prevent "situational" drowsiness.
* **Live HMI Dashboard:** The Flutter app provides a clean, immediate status update ("SAFE", "DROWSY", "AGITATED") and sends push notifications for alerts.
* **Zero-Latency & Privacy-Focused:** The AI Core runs on-device (at the "edge"), ensuring interventions are instant and sensitive facial data never leaves the vehicle.

## 4. 🛠️ Technology Stack & Architecture

Our MVP combines a Python AI backend with a Flutter frontend. The proposed production architecture is designed for an on-device processor.

| Component | Technology |
| :--- | :--- |
| **AI Core (Python)** | `Python 3.9+`, `OpenCV`, `Dlib`, `FER`, `TensorFlow`, `Asyncio`, `WebSockets` |
| **HMI (Flutter App)** | `Flutter`, `Dart`, `web_socket_channel`, `flutter_local_notifications`, `fl_chart` |
| **Hardware Prototypes** | `Arduino Uno`, `MQ3 Alcohol Sensor`, `MQ135 Air Quality Sensor`  |
| **Proposed Full-Stack** | `PostgreSQL` (Database), `Redis` (Cache), `AWS` (Cloud Training/Analytics)  |

### Architecture
The system is built around the **Volo AI Core**, which fuses data from the in-cabin camera, sensors, and the Vehicle CAN Bus. This on-device processing guarantees zero-latency interventions and user privacy.


## 5. 🚀 Getting Started

This project is in two parts: the Python AI server and the Flutter HMI app. You must run both.

### Prerequisites
* Python 3.9+
* Flutter SDK
* An IDE (like VS Code)
* A physical Android/iOS device (for testing with a real IP) or an Emulator

### Part 1: Run the Python AI Core (Server)

1.  **Navigate to the folder:**
    ```bash
    cd volo_mvp/python_ai_core
    ```
2.  **Install dependencies:**
    ```bash
    pip install -r requirements.txt
    ```
3.  **Download Dlib Model:**
    You MUST download the facial landmark predictor model (`shape_predictor_68_face_landmarks.dat`) from [this link](http://dlib.net/files/shape_predictor_68_face_landmarks.dat.bz2).
    * Unzip it and place the `.dat` file inside the `python_ai_core` folder.

4.  **Run the server:**
    ```bash
    python volo_ai_core.py
    ```
    The server will start, load the AI models, and turn on your webcam. You will see `WebSocket server started at ws://0.0.0.0:8765`.

### Part 2: Run the Flutter App (HMI)

1.  **Find your Computer's IP:**
    * **Windows:** Open Command Prompt and type `ipconfig`. Find your "IPv4 Address" (e.g., `192.168.1.10`).
    * **Mac/Linux:** Open a terminal and type `ifconfig | grep inet`.
    * *Note: Your computer and your phone MUST be on the same Wi-Fi network.*

2.  **Update the IP in Flutter:**
    * Open the file: `volo_mvp/flutter_app/lib/services/websocket_service.dart`.
    * Go to the `connect()` method (around line 75).
    * Change the `wsUrl` to use your computer's IP:
        ```dart
        // const wsUrl = 'ws://10.0.2.2:8765'; // Emulator IP
        const wsUrl = 'ws://YOUR_COMPUTER_IP_HERE:8765'; // e.g., 'ws://192.168.1.10:8765'
        ```

3.  **Run the app:**
    ```bash
    cd volo_mvp/flutter_app
    flutter pub get
    flutter run
    ```

### Part 3: Test the Demo!

Look at your webcam. Close your eyes for ~3 seconds. You should see the Python console print "STATE CHANGE: DROWSY" and your Flutter app's "LIVE STATUS" card will instantly turn orange and send a notification.

## 6. 🛣️ Future Scope

Our MVP validates the core AI and hardware concepts. The next steps are:

* **Train the CNN-LSTM Model:** Collect 200+ hours of fusion data (video, CAN bus signals) to train the full production model.
* **Deep CAN Bus Integration:** Move beyond prototypes to read live steering angle, pedal pressure, and vehicle speed from the CAN Bus[cite: 234].
* **Automotive-Grade Sensors:** Upgrade from Arduino to production-ready components, including Force-Sensing Resistors (FSRs) in the steering wheel for grip analysis.
