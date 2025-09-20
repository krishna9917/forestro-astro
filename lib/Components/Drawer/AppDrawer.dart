import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fore_astro_2/Components/ViewImage.dart';
import 'package:fore_astro_2/Components/WalletBox.dart';
import 'package:fore_astro_2/constants/Assets.dart';
import 'package:fore_astro_2/core/extensions/window.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:fore_astro_2/providers/UserProfileProvider.dart';
import 'package:fore_astro_2/providers/sockets/socketProvider.dart';
import 'package:fore_astro_2/screens/auth/LoginScreen.dart';
import 'package:fore_astro_2/screens/main/ProfileScreen.dart';
import 'package:fore_astro_2/screens/pages/CallHistory.dart';
import 'package:fore_astro_2/screens/pages/ChatHistory.dart';
import 'package:fore_astro_2/screens/pages/CouponesScreen.dart';
import 'package:fore_astro_2/screens/pages/MonthlyPayOuts.dart';
import 'package:fore_astro_2/screens/pages/MyReviews.dart';
import 'package:fore_astro_2/screens/pages/NotificationScreen.dart';
import 'package:fore_astro_2/screens/pages/PaymentHistory.dart';
import 'package:fore_astro_2/screens/pages/RaiseAnIssuePage.dart';
import 'package:fore_astro_2/screens/pages/tawk/ChatSupport.dart';
import 'package:fore_astro_2/screens/pages/user/MyFollowes.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> sendNotification() async {
      var url = Uri.parse('https://onesignal.com/api/v1/notifications');
      var headers = {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'ZWE1ODgwNDEtZGM5NC00NjRhLWE1YjEtZjg1ZGNmZDdjYjdk',
      };

      var body = jsonEncode({
        'app_id': "689405dc-4610-4a29-8268-4541a0f6299a",
        'included_segments': ['All'],
        'contents': {'en': 'Hello from OneSignal!'},
      });

      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print('Notification sent successfully!');
      } else {
        print('Failed to send notification: ${response.body}');
      }
    }

    return Container(
      width: context.windowWidth - 80,
      child: Drawer(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Image.asset(
                    AssetsPath.appLogo,
                    width: 100,
                  ),
                  const SizedBox(height: 40),
                  const ProfileCard(),
                  const SizedBox(height: 20),
                  DrawerTiles(
                    image: AssetsPath.userDrawerIconSvg,
                    title: "My Profile",
                    onTap: () {
                      navigateme.push(routeMe(const ProfileScreen()));
                    },
                  ),
                  DrawerTiles(
                    image: AssetsPath.userDrawerIconSvg,
                    title: "Followers",
                    onTap: () {
                      navigateme.push(routeMe(const MyFollowersScreen()));
                    },
                  ),
                  DrawerTiles(
                    image: AssetsPath.walletDrawerIconSvg,
                    title: "My Payment History",
                    onTap: () {
                      navigateme.push(routeMe(const PaymentHistory()));
                    },
                  ),
                  DrawerTiles(
                    image: AssetsPath.walletDrawerIconSvg,
                    title: "Monthly Payouts",
                    onTap: () {
                      navigateme.push(routeMe(MouthlyPayOuts()));
                    },
                  ),
                  DrawerTiles(
                    image: AssetsPath.walletDrawerIconSvg,
                    title: "Coupons",
                    onTap: () {
                      navigateme.push(routeMe(const CouponsScreen()));
                    },
                  ),
                  DrawerTiles(
                    image: AssetsPath.chatDrawerIconSvg,
                    title: "Chat History",
                    onTap: () {
                      navigateme.push(routeMe(const ChatHistory()));
                    },
                  ),
                  DrawerTiles(
                    image: AssetsPath.callDrawerIconSvg,
                    title: "Call History",
                    onTap: () {
                      navigateme.push(routeMe(const CallHistory()));
                    },
                  ),
                  DrawerTiles(
                    image: AssetsPath.bellDrawerIconSvg,
                    title: "Notification",
                    onTap: () {
                      navigateme.push(routeMe(const NotificationScreen()));
                    },
                  ),
                  DrawerTiles(
                    image: AssetsPath.settingDrawerIconSvg,
                    title: "Settings",
                    trailing: button,
                    onTap: () {
                      dynamic state = _menuKey.currentState;
                      state.showButtonMenu();
                    },
                  ),
                  DrawerTiles(
                    image: AssetsPath.chatDrawerIconSvg,
                    title: "Chat Support",
                    onTap: () {
                      navigateme.push(routeMe(const ChatSupport()));
                    },
                  ),
                  DrawerTiles(
                    onTap: () async {
                      context.read<SocketProvider>().logoutUse();
                    },
                    image: AssetsPath.logoutDrawerIconSvg,
                    title: "Log Out",
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasData) {
                        final version = snapshot.data!.version;
                        final buildNumber = snapshot.data!.buildNumber;
                        return Text(
                          "Version: $version ($buildNumber)",
                          style:  GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        );
                      } else {
                        return  Text(
                          "Version: N/A",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        );
                      }
                    },
                  ),
                  // DrawerTiles(
                  //   onTap: () async {
                  //     sendNotification();
                  //   },
                  //   image: AssetsPath.logoutDrawerIconSvg,
                  //   title: "Log Out",
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final userProfile = context.watch<UserProfileProvider>().userProfileModel;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: screenHeight * 0.12, // Adjust height dynamically
          width: screenWidth * 0.9, // Responsive width
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(255, 223, 223, 223),
                blurRadius: 10.0,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03,
              vertical: screenHeight * 0.015,
            ),
            child: Row(
              children: [
                viewImage(
                  name: userProfile?.name ?? "User",
                  url: userProfile?.profileImg,
                  width: screenWidth * 0.15,
                  height: screenWidth * 0.15,
                ),
                SizedBox(width: screenWidth * 0.04),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        userProfile?.name ?? "User",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.045, // Responsive font size
                        ),
                      ),
                      Text(
                        userProfile?.specialization ?? "",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

final GlobalKey _menuKey = GlobalKey();
final button = PopupMenuButton(
    key: _menuKey,
    color: Colors.white,
    surfaceTintColor: Colors.transparent,
    icon: const Icon(Icons.keyboard_arrow_down_outlined),
    itemBuilder: (_) => const <PopupMenuItem<String>>[
          PopupMenuItem<String>(value: 'help', child: Text('Help and Support')),
          PopupMenuItem<String>(
              value: 'reviews', child: Text('Ratings and Reviews')),
        ],
    onSelected: (e) {
      if (e == "help") {
        navigateme.push(routeMe(const RaiseAnIssuePage()));
      } else {
        navigateme.push(routeMe(const MyReviews()));
      }
    });

class DrawerTiles extends StatelessWidget {
  final String image;
  final String title;
  Widget? trailing;
  void Function()? onTap;
  DrawerTiles({
    super.key,
    this.onTap,
    required this.title,
    required this.image,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: const Color.fromARGB(66, 255, 185, 142),
        ),
        child: Center(
          child: SvgPicture.asset(
            image,
            height: 18,
            // color: AppColor.primary,
          ),
        ),
      ),
      title: Text(
        title,
        style:  GoogleFonts.inter(fontSize: 18),
      ),
      trailing: trailing,
    );
  }
}
