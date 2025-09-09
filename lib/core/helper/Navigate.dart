import 'package:flutter/material.dart';
import 'package:fore_astro_2/providers/UserProfileProvider.dart';
import 'package:fore_astro_2/screens/auth/LoginScreen.dart';
import 'package:provider/provider.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

GlobalKey<NavigatorState> navigate = GlobalKey<NavigatorState>();
NavigatorState navigateme = navigate.currentState!;

MaterialPageRoute routeMe(Widget Screen, {bool isauth = false}) {
  return MaterialPageRoute(builder: (context) {
    if (isauth == true &&
        context.read<UserProfileProvider>().userProfileModel == null) {
      return LoginScreen();
    } else {
      return Screen;
    }
  });
}
