import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fore_astro_2/Components/WalletBox.dart';
import 'package:fore_astro_2/core/data/model/UserProfileModel.dart';
import 'package:fore_astro_2/core/data/repository/profileRepo.dart';
import 'package:fore_astro_2/core/extensions/window.dart';
import 'package:fore_astro_2/core/helper/helper.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:fore_astro_2/providers/UserProfileProvider.dart';
import 'package:provider/provider.dart';

class BostProfile extends StatefulWidget {
  const BostProfile({super.key});

  @override
  State<BostProfile> createState() => _BostProfileState();
}

class _BostProfileState extends State<BostProfile> {
  late UserProfileModel userProfileModel;
  bool isBosted = false;
  bool loading = false;
  @override
  void initState() {
    UserProfileProvider userProvider = context.read<UserProfileProvider>();
    userProfileModel = userProvider.userProfileModel!;
    userProvider.reloadProfile();
    isBosted = isOverOneHourOld(userProvider.userProfileModel?.boostedAt);
    super.initState();
  }

  applyBoost() async {
    try {
      setState(() {
        loading = true;
      });
      Response response = await ProfileRepo.boostProfile(
          amount: context
              .read<UserProfileProvider>()
              .userProfileModel!
              .boostCharges!);
      print(response);
      await context.read<UserProfileProvider>().reloadProfile();
      showToast(response.data['message']);
      setState(() {
        isBosted = true;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      showToast("Error to Apply profile Boost");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          WalletBox(),
          SizedBox(width: 15),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment:
                isBosted ? MainAxisAlignment.center : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.offline_bolt_rounded,
                color: AppColor.primary,
                size: isBosted ? 150 : 80,
              ),
              const SizedBox(height: 20),
              Text(
                isBosted
                    ? "Profile Boost is Activated".toUpperCase()
                    : "Boost Your Profile",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              // const SizedBox(height: 10),
              // isBosted
              //     ? const SizedBox()
              //     : const Padding(
              //         padding: EdgeInsets.all(12.0),
              //         child: Text(
              //           "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
              //           textAlign: TextAlign.center,
              //           style: TextStyle(fontSize: 11),
              //         ),
              //       ),
              const SizedBox(height: 20),
              isBosted
                  ? const SizedBox()
                  : Text(
                      "₹ ${context.watch<UserProfileProvider>().userProfileModel?.boostCharges}.00/Hour",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: isBosted
          ? null
          : Container(
              width: context.windowWidth,
              height: 85,
              child: Center(
                child: SizedBox(
                    width: context.windowWidth - 120,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              !isOverTwentyFourHoursOld(
                                      userProfileModel.boostedAt)
                                  ? Colors.grey
                                  : AppColor.primary)),
                      onPressed: !isOverTwentyFourHoursOld(
                                  userProfileModel.boostedAt) ||
                              loading
                          ? null
                          : () {
                              double wallet =
                                  double.parse(userProfileModel.wallet ?? "0");
                              double boostPrice = double.parse(
                                  userProfileModel.boostCharges ?? "0");
                              double resultingBalance = wallet - boostPrice;
                              if (resultingBalance < -100) {
                                showToast("You are insufficient balance.");
                                return;
                              }
                              showToast(
                                  "Boost applied. New balance: $resultingBalance");
                              applyBoost();
                            },
                      child: Text(
                        loading
                            ? "Boosting Profile"
                            : !isOverTwentyFourHoursOld(
                                    userProfileModel.boostedAt)
                                ? "Next Boost Allow After 24 Hours"
                                : "Boost Profile".toUpperCase(),
                      ),
                    )),
              ),
            ),
    );
  }
}
