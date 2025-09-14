import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fore_astro_2/constants/Assets.dart';
import 'package:fore_astro_2/core/data/repository/notificationTokenRepo.dart';
import 'package:fore_astro_2/core/extensions/window.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:fore_astro_2/providers/sockets/socketProvider.dart';
import 'package:fore_astro_2/screens/auth/LoginScreen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WettingScreen extends StatefulWidget {
  String? status;
   WettingScreen({super.key, this.status});

  @override
  State<WettingScreen> createState() => _WettingScreenState();
}

class _WettingScreenState extends State<WettingScreen> {
  addNotificatinToken() async {
    try {
      await NotificationRepo.setToken();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    addNotificatinToken();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.bgcolor,
      child: Stack(
        children: [
          Image.asset(
            AssetsPath.appBg,
            width: context.windowWidth,
            height: context.windowHeight,
            fit: BoxFit.cover,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 120),
                    const Text(
                      'Profile Status',
                      style: TextStyle(
                        color: Color(0xFF201F1F),
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 50),
                    Image.asset(AssetsPath.wettingIcon),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: context.windowWidth / 1.5,
                      child: Text(
                        widget.status == "pending"?
                        'Your profile has not yet been approved':"Your profile has been rejected",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF201F1F),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: context.windowWidth / 1.3,
                      child: const Text(
                        'Our team will review your profile and notify you once it has been approved. Thank you for your patience.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF515151),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Spacer(),
                    TextButton(
                        onPressed: () async {
                          await context.read<SocketProvider>().logoutUse();
                        },
                        child: Text("Logout ")),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
