import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  // 1. Define the Android Notification Channel
  final AndroidNotificationChannel _androidChannel =
      const AndroidNotificationChannel(
    'volo_alerts', // id
    'Volo Driver Alerts', // title
    description: 'Notifications for driver drowsiness or agitation.',
    importance: Importance.max,
    playSound: true,
  );

  Future<void> init() async {
    // 2. Initialization Settings for Android
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // 3. Initialization Settings for iOS
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // 4. Initialize the plugin
    await _plugin.initialize(settings);

    // 5. Create the Android channel
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);
    
    // 6. Request notification permissions for Android 13+
    await _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  }

  // 7. Method to show a notification
  void showNotification(String title, String body) {
    _plugin.show(
      0, // Notification ID
      title,
      body,
      NotificationDetails(
        // 8. Use our Android Channel
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          icon: '@mipmap/ic_launcher',
          importance: Importance.max,
          priority: Priority.high,
        ),
        // 9. Basic iOS settings
        iOS: const DarwinNotificationDetails(
          sound: 'default.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }
}