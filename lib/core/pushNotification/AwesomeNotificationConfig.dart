import 'dart:convert';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:fore_astro_2/core/utils/NotificartionManager.dart';

Future initAwesomeNotification() async {
  await AwesomeNotifications().initialize(
    "resource://drawable/ic_launcher",
    [
      NotificationChannel(
        channelGroupKey: 'astro',
        channelKey: 'astro_key',
        channelName: 'Astro Notification',
        channelDescription: 'Notification channel for basic tests',
        playSound: true,
        enableVibration: true,
      ),
    ],
    channelGroups: [
      NotificationChannelGroup(
          channelGroupKey: 'astro_channel_group',
          channelGroupName: 'astro group')
    ],
    debug: true,
  );
}

setAwesomeNotificationsListeners() {
  AwesomeNotifications().setListeners(
    onActionReceivedMethod: (ReceivedAction receivedAction) async {
      await NotificationController.onActionReceivedMethod(receivedAction);
    },
    onNotificationCreatedMethod:
        (ReceivedNotification receivedNotification) async {
      await NotificationController.onNotificationCreatedMethod(
        receivedNotification,
      );
    },
    onNotificationDisplayedMethod:
        (ReceivedNotification receivedNotification) async {
      await NotificationController.onNotificationDisplayedMethod(
        receivedNotification,
      );
    },
    onDismissActionReceivedMethod: (ReceivedAction receivedAction) async {
      await NotificationController.onDismissActionReceivedMethod(
        receivedAction,
      );
    },
  );
}

class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
    print("ok");
  }
}

pushAwesomeNotifications(
    {Map<String, dynamic>? payload,
    required String title,
    required String body}) async {
  await NotificationManager.addNotifications(
    date: payload?['date'] ?? DateTime.now().toIso8601String(),
    id: payload?['id'] ?? null,
    subtitle: body,
    title: title,
    type: payload?['type'] ?? "default",
    userId: payload?['userId'] ?? null,
  );

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: Random().nextInt(11),
      channelKey: 'astro_key',
      actionType: ActionType.Default,
      title: title,
      body: body,
      payload: {
        "data": jsonEncode(payload),
      },
      wakeUpScreen: true,
      backgroundColor: AppColor.primary,
      color: Colors.white,
      chronometer: Duration(seconds: 1),
      hideLargeIconOnExpand: true,
    ),
  );
  // actionButtons: [
  //   NotificationActionButton(
  //     key: "Answer",
  //     label: "Answer",
  //   ),
  //   NotificationActionButton(key: "Decline", label: "Decline"),
  // ]);
}
