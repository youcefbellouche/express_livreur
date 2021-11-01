// ignore_for_file: file_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// ignore: camel_case_types
class FirabasePushNotif {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin _localNotification =
      FlutterLocalNotificationsPlugin();

  static Future<void> _requestPermission() async {
    if (Platform.isAndroid) return;

    await _messaging.requestPermission();
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Stream<RemoteMessage> get onMessage {
    FlutterAppBadger.updateBadgeCount(1);

    return FirebaseMessaging.onMessage;
  }

  static Stream<RemoteMessage> get onMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;

  static Future<void> initialize(
    SelectNotificationCallback onSelectNotification,
  ) async {
    await _messaging.getInitialMessage();
    await _requestPermission();

    await _initializeLocalNotification(onSelectNotification);
    await _configureAndroidChannel();

    await _openInitialScreenFromMessage(onSelectNotification);
  }

  static void invokeLocalNotification(RemoteMessage remoteMessage) async {
    FlutterAppBadger.updateBadgeCount(1);

    RemoteNotification? notification = remoteMessage.notification;
    AndroidNotification? android = remoteMessage.notification?.android;
    if (notification != null && android != null) {
      await _localNotification.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
              'Rev', // id
              'Express Livreur', // title
              icon: android.smallIcon,
              sound: const RawResourceAndroidNotificationSound('key_sound'),
              importance: Importance.max,
              playSound: true,
              priority: Priority.max),
        ),
        payload: jsonEncode(remoteMessage.data),
      );
    }
  }

  static Future<void> _configureAndroidChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'Rev', // id
        'Express Livreur', // title/ description
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound('key_sound'),
        playSound: true);

    await _localNotification
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> _openInitialScreenFromMessage(
    SelectNotificationCallback onSelectNotification,
  ) async {
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage?.data != null) {
      onSelectNotification(jsonEncode(initialMessage!.data));
    }
  }

  static Future<void> _initializeLocalNotification(
    SelectNotificationCallback onSelectNotification,
  ) async {
    const android = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const ios = IOSInitializationSettings();

    const initsetting = InitializationSettings(android: android, iOS: ios);

    await _localNotification.initialize(
      initsetting,
      onSelectNotification: onSelectNotification,
    );
  }
}
