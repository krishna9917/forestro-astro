import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_astro_2/Components/Actions/Toggleonline.dart';
import 'package:fore_astro_2/Components/BottamBar/AppBottamNavbar.dart';
import 'package:fore_astro_2/Components/Drawer/AppDrawer.dart';
import 'package:fore_astro_2/constants/Assets.dart';
import 'package:fore_astro_2/core/data/model/UserProfileModel.dart';
import 'package:fore_astro_2/core/data/repository/notificationTokenRepo.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:fore_astro_2/core/helper/helper.dart';
import 'package:fore_astro_2/core/pushNotification/AwesomeNotificationConfig.dart';
import 'package:fore_astro_2/core/pushNotification/Notification.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:fore_astro_2/providers/ComunicationProvider.dart';
import 'package:fore_astro_2/providers/NotificationProvider.dart';
import 'package:fore_astro_2/providers/UserProfileProvider.dart';
import 'package:fore_astro_2/providers/bankAccoutProvider.dart';
import 'package:fore_astro_2/providers/sessionProvider.dart';
import 'package:fore_astro_2/providers/sockets/socketProvider.dart';
import 'package:fore_astro_2/screens/Comunication/sendremedy/SendRemedyScreen.dart';
import 'package:fore_astro_2/screens/main/Tabs/FeedScreen.dart';
import 'package:fore_astro_2/screens/main/Tabs/LivetabView.dart';
import 'package:fore_astro_2/screens/main/Tabs/ProfileTabView.dart';
import 'package:fore_astro_2/screens/pages/BostProfilePage.dart';
import 'package:fore_astro_2/screens/pages/NotificationScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import 'Tabs/HomeTabView.dart';

class HomeTabScreen extends StatefulWidget {
  HomeTabScreen({super.key});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen>
    with WidgetsBindingObserver {
  int tabindex = 0;
  Timer? _reloadTimer;

  @override
  void initState() {
    // Provider.of<UserProfileProvider>(context).getUserDataSplash();
    onInitTask();
    WidgetsBinding.instance.addObserver(this);
    initOneSignal();

    super.initState();
  }

  AppLifecycleState? _notification;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (AppLifecycleState.detached == state) {
      SocketProvider data = context.read<SocketProvider>();
      SessionProvider session = context.read<SessionProvider>();

      if (data.iAmWorkScreen) {
        session.closeSession();
        data.closeSession(
          senderId: data.workdata!['userId'].toString(),
          userType: data.workdata!['userType'],
          requestType: data.workdata!['requestType'],
          message: "Astrologer Quit From Application",
          communicationId: data.workdata!['data']['id'].toString(),
        );
      }
    }
  }

  onInitTask() async {
    print("Task init");
    NotificationService.addFirebaseListen();
    setAwesomeNotificationsListeners();
    UserProfileModel user =
        context.read<UserProfileProvider>().userProfileModel!;
    // Ensure astro_id is persisted for API layers that read from SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentId = prefs.getString("id");
      final targetId = user.astroId?.toString();
      if (targetId != null && targetId.isNotEmpty && currentId != targetId) {
        await prefs.setString("id", targetId);
      }
    } catch (_) {}
    try {
      final String targetId = "${user.astroId}-astro";
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          await ZIMKit().connectUser(
            id: targetId,
            name: user.name!,
            avatarUrl: user.profileImg ?? AssetsPath.avatarPic,
          );
        } catch (e) {
          print(e);
        }
      });
    } catch (e) {
      print(e);
    }
    context.read<BankAccountProvider>().initLoadBanks();
    await context.read<CommunicationProvider>().loadInitData();
    // context.read<UserProfileProvider>().getUserDataSplash();
    context.read<SocketProvider>().initSocketConnection().then((value) {
      if (value?.active == true) {
        context.read<SocketProvider>().addSocketListeners();
      }
    });
    print("INIt");
    await NotificationRepo.setToken();
    await NotificationRepo.sendsignal();

    // Start periodic reload only after initial data and IDs are ready
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString("id");
      final token = prefs.getString("token");
      _reloadTimer?.cancel();
      if (mounted && id != null && id.isNotEmpty && token != null && token.isNotEmpty) {
        _reloadTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
          if (!mounted) return;
          context.read<CommunicationProvider>().reloadComunication();
        });
      }
    } catch (_) {}
  }

  Future<void> initOneSignal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString("id");

    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize("689405dc-4610-4a29-8268-4541a0f6299a");
    OneSignal.Notifications.requestPermission(true);
    var externalId = id;
    OneSignal.login(externalId!);
    await Future.delayed(const Duration(seconds: 2));
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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _reloadTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Builder(
          builder: (context) {
            final userProfile =
                context.watch<UserProfileProvider>().userProfileModel;
            final userName = userProfile?.name?.split(" ").first ?? "User";
            final userStatus = userProfile?.profileStatus == "trainee"
                ? "Trainee"
                : userProfile?.name?.split(" ").last ?? "Welcome Back";

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi $userName,',
                  style: GoogleFonts.inter(
                    color: Color(0xFF201F1F),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  userStatus,
                  style: GoogleFonts.inter(
                    color: Color(0xFF353433),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          Builder(
            builder: (context) {
              final userProfile =
                  context.watch<UserProfileProvider>().userProfileModel;
              return Visibility(
                visible: userProfile?.profileStatus == "trainee",
                child: IconButton(
                  onPressed: () {
                    showToast("You are now in Trainee stage");
                  },
                  icon: Icon(
                    FontAwesomeIcons.graduationCap,
                    color: AppColor.primary,
                    size: 20,
                  ),
                ),
              );
            },
          ),
          Center(child: toggleButtons),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {
                navigateme.push(routeMe(const NotificationScreen()));
              },
              icon: Badge(
                backgroundColor: AppColor.primary,
                label: Consumer<NotificationProvider>(
                  builder: (context, data, child) {
                    return Text((data.notificationData.length).toString());
                  },
                ),
                child: SvgPicture.asset(
                  AssetsPath.bellIconSvg,
                  width: 22,
                  height: 22,
                ),
              ),
            ),
          ),
        ],
      ),
      body: [
        const HomeTabView(),
        const FeedTabView(),
        const LiveTabView(),
        const ProfiletabView()
      ][tabindex],
      drawer: const AppDrawer(),
      floatingActionButton: tabindex == 0
          ? FloatingActionButton(
              onPressed: () {
                navigateme.push(routeMe(const SendRemedyScreen()));
              },
              child: const Icon(
                Icons.edit_note_rounded,
                color: Colors.white,
              ),
            )
          : tabindex == 3
              ? FloatingActionButton(
                  onPressed: () {
                    navigateme.push(routeMe(const BostProfile()));
                  },
                  mini: isOverOneHourOld(context
                      .watch<UserProfileProvider>()
                      .userProfileModel
                      ?.boostedAt),
                  backgroundColor: isOverOneHourOld(context
                          .watch<UserProfileProvider>()
                          .userProfileModel
                          ?.boostedAt)
                      ? Colors.grey
                      : AppColor.primary,
                  child: const Icon(
                    Icons.bolt_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                )
              : null,
      bottomNavigationBar: AppBottamNavBar(tabindex,
          onTap: (e) => setState(() {
                tabindex = e;
              })),
    );
  }
}
