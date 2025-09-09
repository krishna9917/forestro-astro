import 'package:flutter/material.dart';
import 'package:fore_astro_2/core/data/model/NotificationModel.dart';
import 'package:fore_astro_2/core/extensions/Text.dart';
import 'package:fore_astro_2/core/pushNotification/AwesomeNotificationConfig.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:fore_astro_2/core/utils/NotificartionManager.dart';
import 'package:fore_astro_2/providers/NotificationProvider.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    context.read<NotificationProvider>().loadNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications".toUpperCase()),
      ),
      body: Consumer<NotificationProvider>(builder: (context, data, child) {
        if (data.notificationData.isEmpty) {
          return const Center(
            child: Text("No Notification Found"),
          );
        }
        return ListView.builder(
          itemCount: data.notificationData.length,
          itemBuilder: (context, index) {
            NotificationModel model = data.notificationData[index];
            return Dismissible(
              key: UniqueKey(),
              onDismissed: (v) async {
                NotificationManager.removeNotifications(index);
                await context.read<NotificationProvider>().loadNotification();
              },
              background: Container(
                color: Colors.red,
              ),
              child: ListTile(
                leading: NotificationManager.getNotificationIcon(
                    model.type.toString()),
                title: Text(
                  "${model.title}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text("${model.subtitle}"),
                trailing: Text("${model.date}".formatDate()),
              ),
            );
          },
        );
      }),
    );
  }
}
