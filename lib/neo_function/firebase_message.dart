import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import '../pages/user_page/nickname.dart';

void requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print("User granted permission");
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
}

void saveToken(String token) async {
  await FirebaseFirestore.instance
      .collection('UserTokens')
      .doc('$useruid')
      .set({
    'token': token,
  });
}

initInfo() {
  var androidInitialize = const AndroidInitializationSettings('@mipmap/icon');
  var iOSIntialize = const IOSInitializationSettings();
  var initializationSettings =
      InitializationSettings(android: androidInitialize, iOS: iOSIntialize);
  FlutterLocalNotificationsPlugin().initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
    try {
      if (payload != null && payload.isNotEmpty) {
      } else {}
    } catch (e) {
      return;
    }
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print("...........................onMessage...........");
    print(
        "onMessage: ${message.notification?.title}/${message.notification?.body}");

    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      message.notification!.body.toString(),
      htmlFormatBigText: true,
      contentTitle: message.notification!.title.toString(),
      htmlFormatContentTitle: true,
    );

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('neologism', 'neologism', 'neologism',
            importance: Importance.high,
            styleInformation: bigTextStyleInformation,
            priority: Priority.high,
            playSound: false);
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const IOSNotificationDetails());

    await FlutterLocalNotificationsPlugin().show(0, message.notification?.title,
        message.notification?.body, platformChannelSpecifics,
        payload: message.data['body']);
  });
}

sendPushMessage(String token, String body, String title) async {
  try {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            "key=AAAALpJl9DQ:APA91bFzoDSGELrSf5-13j06zMyquriY3FJFHmR2BkPWlovoyXj7eSAUuS1qzD1BATDXYfD3UYYYo2IBMa3jexQbdsgz-VvyHxmlkkyCBTUqR6mw-vXQwOZRG3gfOOTqxypbg-ZvwpPJ"
      },
      body: jsonEncode(<String, dynamic>{
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'status': 'done',
          'body': body,
          'title': title,
        },
        "notification": <String, dynamic>{
          "title": title,
          "body": body,
          "android_channel_id": "neologism"
        },
        "to": token,
      }),
    );
  } catch (e) {}
}
