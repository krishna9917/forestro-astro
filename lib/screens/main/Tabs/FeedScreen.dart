import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_astro_2/constants/Assets.dart';
import 'package:fore_astro_2/core/data/model/TotalReportMModel.dart';
import 'package:fore_astro_2/core/data/repository/communicationRepo.dart';
import 'package:fore_astro_2/core/extensions/window.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:fore_astro_2/providers/UserProfileProvider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FeedTabView extends StatefulWidget {
  const FeedTabView({super.key});

  @override
  State<FeedTabView> createState() => _FeedTabViewState();
}

class _FeedTabViewState extends State<FeedTabView> {
  bool loading = true;
  TotalReportModel totalReportModel = TotalReportModel(
    numberOfAudioCall: 0,
    numberOfChats: 0,
    numberOfVideoCalls: 0,
    status: true,
    totalEarning: "0",
  );

  Future<void> loadData() async {
    try {
      Response data = await CommunicationRepo.totalReport();

      setState(() {
        totalReportModel = TotalReportModel.fromJson(data.data);
        loading = false;
      });
      await context.read<UserProfileProvider>().reloadProfile();
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: RefreshIndicator(
        onRefresh: loadData, // Calls loadData() on pull down
        child: Builder(builder: (context) {
          if (loading) {
            return SizedBox(
              height: context.windowHeight - 300,
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColor.primary,
                  strokeCap: StrokeCap.round,
                ),
              ),
            );
          }
          return ListView(
            children: [
              const SizedBox(height: 15),
              StatusBox(
                icon: Icon(
                  Icons.wallet,
                  color: AppColor.primary,
                  size: 32,
                ),
                title: "Wallet Balance",
                value:
                    "${context.watch<UserProfileProvider>().userProfileModel?.wallet}",
              ),
              const SizedBox(height: 15),
              StatusBox(
                icon: Icon(
                  FontAwesomeIcons.phone,
                  color: AppColor.primary,
                ),
                title: "Total No. of Calls",
                value: "${totalReportModel.numberOfAudioCall}",
              ),
              const SizedBox(height: 15),
              StatusBox(
                icon: Icon(
                  FontAwesomeIcons.video,
                  color: AppColor.primary,
                ),
                title: "Total No. of Video Calls",
                value: "${totalReportModel.numberOfVideoCalls}",
              ),
              const SizedBox(height: 15),
              StatusBox(
                icon: Icon(
                  Icons.chat_bubble_rounded,
                  color: AppColor.primary,
                ),
                title: "Total No. Chats",
                value: "${totalReportModel.numberOfChats}",
              ),
              const SizedBox(height: 15),
              StatusBox(
                icon: SvgPicture.asset(
                  AssetsPath.earningIconSvg,
                  width: 28,
                  height: 28,
                ),
                title: "Total Earnings",
                value: "${totalReportModel.totalEarning}",
              ),
              const SizedBox(height: 15),
            ],
          );
        }),
      ),
    );
  }
}

class StatusBox extends StatelessWidget {
  final Widget icon;
  final String title;
  final String value;

  const StatusBox({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      width: context.windowWidth,
      height: 70,
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(113, 242, 196, 31),
            Color.fromARGB(107, 247, 141, 41)
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(2, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              icon,
              const SizedBox(width: 15),
              Text(
                '$title',
                style:  GoogleFonts.inter(
                  color: Color(0xFF201F1F),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            '$value',
            style: GoogleFonts.inter(
              color: Color(0xFF141414),
              fontSize: 20,
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          )
        ],
      ),
    );
  }
}
