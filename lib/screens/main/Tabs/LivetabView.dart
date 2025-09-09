
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fore_astro_2/constants/Assets.dart';
import 'package:fore_astro_2/core/data/model/UserProfileModel.dart';
import 'package:fore_astro_2/core/extensions/Text.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:fore_astro_2/core/helper/helper.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:fore_astro_2/providers/UserProfileProvider.dart';
import 'package:fore_astro_2/providers/liveDataProvider.dart';
import 'package:fore_astro_2/screens/Comunication/live/LiveScreen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class LiveTabView extends StatefulWidget {
  const LiveTabView({super.key});

  @override
  State<LiveTabView> createState() => _LiveTabViewState();
}

class _LiveTabViewState extends State<LiveTabView> {
  @override
  void initState() {
    context.read<LiveDataProvider>().liveHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<LiveDataProvider>(builder: (context, state, child) {
        if (state.loading) {
          return const Center(
              child: CircularProgressIndicator(
            strokeCap: StrokeCap.round,
          ));
        }
        if (state.historyData.isEmpty) {
          return const Center(
            child: Text("No History Found"),
          );
        }
        return RefreshIndicator(
          color: AppColor.primary,
          onRefresh: () async {
            await context.read<LiveDataProvider>().liveHistory();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: Column(
                children: List.generate(
                  state.historyData.length,
                  (index) => ListTile(
                    leading: SvgPicture.asset(
                      AssetsPath.liveIconSvg,
                      color: AppColor.primary,
                      width: 23,
                      height: 23,
                    ),
                    // ignore: prefer_interpolation_to_compose_strings
                    title: Text(
                      state.historyData[index].time + " Min",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      state.historyData[index].dateTime
                          .toIso8601String()
                          .formatDate(),
                      style: const TextStyle(fontSize: 10),
                    ),
                    trailing: Text(
                      " - ₹" + state.historyData[index].totalAmount,
                      style:
                          const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        extendedPadding: const EdgeInsets.symmetric(horizontal: 20),
        onPressed: () async {
          // loadData();
          UserProfileModel userProfileModel =
              context.read<UserProfileProvider>().userProfileModel!;
          double wallet = double.parse(userProfileModel.wallet ?? "0");
          double liveCharges =
              double.parse(userProfileModel.astrologerLiveChargesPerMin ?? "0");

          if (wallet < liveCharges) {
            showToast("insufficient account balance.");
            return;
          }

          Uuid uuid = const Uuid();
          navigateme.push(
            routeMe(
              LiveScreen(
                liveID: uuid.v4(),
              ),
            ),
          );
        },
        label: const Text(
          " Go Live ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        icon: SvgPicture.asset(
          AssetsPath.liveIconSvg,
          color: Colors.white,
          width: 20,
          height: 20,
        ),
      ),
    );
  }
}
