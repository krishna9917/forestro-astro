import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fore_astro_2/core/data/model/NotificationModel.dart';
import 'package:fore_astro_2/core/utils/NotificartionManager.dart';

class NotificationProvider with ChangeNotifier {
  List<NotificationModel> _notificationData = [];
  List<NotificationModel> get notificationData => _notificationData;

  NotificationProvider() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      loadNotification();
    });
  }

  loadNotification() async {
    List<NotificationModel> loadNotificationData =
        await NotificationManager.getNotifications();
    if (loadNotificationData.length != notificationData.length) {
      _notificationData = loadNotificationData;
      notifyListeners();
    }
  }
}
