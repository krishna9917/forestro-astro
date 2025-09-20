import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:fore_astro_2/core/pushNotification/Notification.dart';
import 'package:fore_astro_2/core/theme/AppTheme.dart';
import 'package:fore_astro_2/firebase_options.dart';
import 'package:fore_astro_2/providers/ComunicationProvider.dart';
import 'package:fore_astro_2/providers/CouponProvider.dart';
import 'package:fore_astro_2/providers/NotificationProvider.dart';
import 'package:fore_astro_2/providers/UserProfileProvider.dart';
import 'package:fore_astro_2/providers/bankAccoutProvider.dart';
import 'package:fore_astro_2/providers/liveDataProvider.dart';
import 'package:fore_astro_2/providers/sessionProvider.dart';
import 'package:fore_astro_2/providers/sockets/socketProvider.dart';
import 'package:fore_astro_2/screens/splash/SplashScreen.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");

  // Start foreground task to play audio
}

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await ZIMKit().init(
    appID: 1230629691,
    appSign: '16464f848f6510fb18fef88047b37ddb297aeca244a348dc5b0151d40d192c86',
  );
debugPrint('main');
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(
    NotificationService.firebaseMessagingBackgroundHandler,
  );

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    statusBarColor: Colors.transparent,
  ));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProfileProvider()),
        ChangeNotifierProvider(create: (context) => BankAccountProvider()),
        ChangeNotifierProvider(create: (context) => CommunicationProvider()),
        ChangeNotifierProvider(create: (context) => SessionProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
        ChangeNotifierProvider(create: (context) => CouponProvider()),
        ChangeNotifierProvider(create: (context) => LiveDataProvider()),
        ChangeNotifierProxyProvider(
          create: (context) => SocketProvider(
            communicationProvider: context.read<CommunicationProvider>(),
          ),
          update: (context, communicationProvider, previousSocketProvider) =>
              previousSocketProvider!,
        )
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> initOneSignal() async {
  String generateRandomOrderId() {
    var random = Random();
    int randomNumber = 10000 + random.nextInt(90000);
    return '$randomNumber';
  }

  String externalIdg = generateRandomOrderId();

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("689405dc-4610-4a29-8268-4541a0f6299a");
  OneSignal.Notifications.requestPermission(true);
  var externalId = externalIdg;
  OneSignal.login(externalId);

  _handleGetExternalId();
  // _handleLogin();
}

void _handleGetExternalId() async {
  var externalId = await OneSignal.User.getExternalId();
  print('External ID: $externalId');
  if (externalId != null) {
    print('IDSIGNAL: $externalId');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('externalId', externalId ?? '');
    // await NotificationRepo.sendsignal();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: MaterialApp(
        title: "Fore Astro Astrologer",
        theme: appTheme,
        debugShowCheckedModeBanner: false,
        navigatorKey: navigate,
        scaffoldMessengerKey: snackbarKey,
        home: const SplashScreen(),
        builder: (context, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _checkForUpdate(context);
          });
          return child!;
        },
        // home: SendRemedyScreen(),
      ),
    );
  }
}

Future<void> _checkForUpdate(BuildContext context) async {
  try {
    AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
    if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
      if (updateInfo.immediateUpdateAllowed) {
        await InAppUpdate.performImmediateUpdate();
      } else if (updateInfo.flexibleUpdateAllowed) {
        await InAppUpdate.startFlexibleUpdate();
        await InAppUpdate.completeFlexibleUpdate();
      }
    }
  } catch (e) {
    debugPrint("Error checking for updates: $e");
  }
}
