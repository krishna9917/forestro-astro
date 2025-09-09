import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fore_astro_2/core/data/model/NotificationModel.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationManager {
  NotificationManager._();
  static String key = "notifications";
  static Future<List<NotificationModel>> getNotifications() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    List<String>? data = storage.getStringList(key);
    if (data == null) {
      return [];
    }

    return data.reversed
        .toList()
        .map((e) => NotificationModel.fromJson(jsonDecode(e)))
        .toList();
  }

  static Future<bool> addNotifications(
      {title, subtitle, date, id, userId, type}) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    Map newNotification = NotificationModel(
            date: date,
            userId: userId,
            type: type,
            id: id,
            subtitle: subtitle,
            title: title)
        .toJson();
    List<String>? data = storage.getStringList(key);
    if (data == null) {
      return await storage.setStringList(key, [jsonEncode(newNotification)]);
    } else {
      return await storage
          .setStringList(key, [...data, jsonEncode(newNotification)]);
    }
  }

  static Future<bool> removeNotifications(int index) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    List<String>? data = storage.getStringList(key);
    if (data == null) {
      return true;
    } else {
      data.removeAt(index);
      return await storage.setStringList(key, data);
    }
  }

  static Icon getNotificationIcon(String type) {
    switch (type.toLowerCase()) {
      case "call":
        return Icon(
          Icons.call,
          color: AppColor.primary,
        );
      case "chat":
        return Icon(
          Icons.chat,
          color: AppColor.primary,
        );
      case "video":
        return Icon(
          Icons.video_camera_back_rounded,
          color: AppColor.primary,
        );
      case "follow":
        return Icon(
          Icons.person,
          color: AppColor.primary,
        );
      case "payout":
        return Icon(
          Icons.payment,
          color: AppColor.primary,
        );
      case "payment":
        return Icon(
          Icons.payment,
          color: AppColor.primary,
        );
      default:
        return Icon(
          Icons.notifications,
          color: AppColor.primary,
        );
    }
  }
}
