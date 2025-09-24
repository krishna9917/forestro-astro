import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fore_astro_2/screens/internetConnection/NoInternetPage.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fore_astro_2/constants/Assets.dart';
import 'package:fore_astro_2/constants/ZegoKeys.dart';
import 'package:fore_astro_2/core/data/repository/authRepo.dart';
import 'package:fore_astro_2/core/extensions/window.dart';
import 'package:fore_astro_2/core/pushNotification/Notification.dart';
import 'package:fore_astro_2/providers/UserProfileProvider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String _version = '';
  String _buildNumber = '';

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();
    get();
    _checkInternetAndInitialize();
// Here Our Task
//     Timer(const Duration(seconds: 1), () async {
//       // ZIMKit().init(
//       //   notificationConfig: ZegoZIMKitNotificationConfig(
//       //       androidNotificationConfig: ZegoZIMKitAndroidNotificationConfig(),
//       //       iosNotificationConfig: ZegoZIMKitIOSNotificationConfig()),
//       //   appID: ZegoKeys.appId,
//       //   appSign: ZegoKeys.appSign,
//       // )
//       //     .then((e) async {
//
//     //   }).catchError((e) {
//     //     print(
//     //         "error----------------------------------------------------------------  ");
//     //     print(e);
//     //   });
//     });
  }

  Future<void> _checkInternetAndInitialize() async {
    try {
      final results = await Connectivity().checkConnectivity();
      if (results.contains(ConnectivityResult.none)) {
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const NoInternetPage()),
          (route) => false,
        );
        return;
      }
      // if needed add listeners in providers later
    } catch (_) {}
  }

  get() async {
    await requestPermissions();
    await context.read<UserProfileProvider>().getUserDataSplash();
  }

  Future<void> _loadPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
    });
    try {
      await AuthRepo.version(_version, _buildNumber)
          .timeout(const Duration(seconds: 4));
    } catch (_) {
      // ignore version ping failure/redirect; don't block splash
    }
    // print(
    //     "build version number =======>>>>>>>>>>>>$_version $_buildNumber $response");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> requestPermissions() async {
    await [
      Permission.camera,
      Permission.microphone,
    ].request();
    await NotificationService.initNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          children: [
            SpinAstro(controller: _controller),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 65),
                  Image.asset(
                    AssetsPath.appLogo,
                    width: 210,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 50),
                    child: const Text("Powered by Fore Astro"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SpinAstro extends StatelessWidget {
  const SpinAstro({
    super.key,
    required AnimationController controller,
  }) : _controller = controller;

  final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * 2.0 * 3.14,
            child: Image.asset(
              AssetsPath.splashSpinnerBg,
              width: context.windowWidth + 3000,
              fit: BoxFit.fill,
            ),
          );
        },
      ),
    );
  }
}
