import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fore_astro_2/core/data/api/ApiRequest.dart';
import 'package:fore_astro_2/core/pushNotification/AwesomeNotificationConfig.dart';
import 'package:fore_astro_2/providers/sockets/web_socket.dart';

class NotificationService {
  static Future<void> initNotification() async {
    await initAwesomeNotification();
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
      if (!isAllowed) {
        bool status =
            await AwesomeNotifications().requestPermissionToSendNotifications();
        if (status) {
          NotificationSettings settings = await messaging.requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
          );
          print(settings.authorizationStatus);
          if (settings.authorizationStatus == AuthorizationStatus.authorized) {
            await initAwesomeNotification();
          }
        }
      }
    });
  }

  static addFirebaseListen() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        pushAwesomeNotifications(
          title: message.notification!.title.toString(),
          body: message.notification!.body.toString(),
          payload: message.data,
        );
      }
    });
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      pushAwesomeNotifications(
        title: message.notification!.title.toString(),
        body: message.notification!.body.toString(),
        payload: message.data,
      );
    }
    print("Handling a background message: ${message.messageId}");
  }

  static Future sendPushMessage(
    String token, {
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    try {
      ApiRequest request =
          ApiRequest(socketHost + "/notify", method: "POST", body: {
        "token": token,
        "notification": <String, dynamic>{
          'title': title,
          'body': body,
          "data": data,
        },
      });
      await request.send();
    } catch (e) {
      print(e);
    }
  }
}
