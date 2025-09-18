import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fore_astro_2/constants/Assets.dart';
import 'package:fore_astro_2/constants/ZegoKeys.dart';
import 'package:fore_astro_2/core/data/model/UserProfileModel.dart';
import 'package:fore_astro_2/core/data/repository/liveRepo.dart';
import 'package:fore_astro_2/core/data/repository/profileRepo.dart';
import 'package:fore_astro_2/core/helper/helper.dart';
import 'package:fore_astro_2/providers/UserProfileProvider.dart';
import 'package:fore_astro_2/providers/liveDataProvider.dart';
import 'package:fore_astro_2/providers/sockets/socketProvider.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class LiveScreen extends StatefulWidget {
  final String liveID;
  final bool isHost;

  const LiveScreen({Key? key, required this.liveID, this.isHost = true})
      : super(key: key);

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  UserProfileModel? userProfileProvider;
  late SocketProvider socketProvider;
  Timer? liveTimer;

  void startLiveTimer() {
    double amount = double.parse(userProfileProvider?.wallet ?? "0");
    double chargesPerMin =
        double.parse(userProfileProvider?.astrologerLiveChargesPerMin ?? "0");
    if (chargesPerMin == 0) {
      showToast("You are in a free live session.");
      return;
    }

    int liveDuration = ((amount / chargesPerMin) * 60).toInt();
    if (liveDuration > 0) {
      liveTimer = Timer(Duration(seconds: liveDuration), () {
        socketProvider.endLiveSession();
        showToast("Your live session has ended. Your account balance is low.");
        Navigator.of(context).pop();
      });
    } else {
      showToast("Insufficient balance to start a live session.");
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    userProfileProvider = context.read<UserProfileProvider>().userProfileModel;
    socketProvider = context.read<SocketProvider>();
    context.read<UserProfileProvider>().reloadProfile();
    super.initState();
  }

  @override
  void dispose() {
    liveTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: ZegoUIKitPrebuiltLiveStreaming(
          events: ZegoUIKitPrebuiltLiveStreamingEvents(
            onEnded: (event, defaultAction) {
              socketProvider.endLiveSession();
              context.read<UserProfileProvider>().reloadProfile();
              context.read<LiveDataProvider>().liveHistory();
              liveTimer?.cancel();
              return defaultAction();
            },
            onLeaveConfirmation: (event, defaultAction) {
              return defaultAction();
            },
            onStateUpdated: (ZegoLiveStreamingState state) {
              if (state == ZegoLiveStreamingState.living) {
                showToast("Live  streaming Start");
                // startLiveTimer();

                socketProvider.startLiveSession(
                    chegesPerMin: double.parse(context
                            .read<UserProfileProvider>()
                            .userProfileModel
                            ?.astrologerLiveChargesPerMin ??
                        "0"),
                    userId: userProfileProvider!.astroId!,
                    name: userProfileProvider!.name!,
                    profile:
                        userProfileProvider!.profileImg ?? AssetsPath.avatarPic,
                    liveId: widget.liveID,
                    data: userProfileProvider!.toJson());
                LiveRepo.sendPushNotification(
                    title: "${userProfileProvider?.name} in Live.",
                    body: "Join Her Live Stream Now and Ask Your Questions!",
                    content: {
                      "name": userProfileProvider?.name ?? "",
                      "streamId": widget.liveID.toString(),
                      "profileImage": userProfileProvider?.profileImg ?? "",
                      "startAt": DateTime.now().toIso8601String(),
                    });
              }
            },
          ),
          appID: 2101331696,
          appSign: '77838d88881dda6ac10b83406f2fb2027e946802d016035e98b58e7af4823dba',
          userID: userProfileProvider!.astroId.toString(),
          userName: userProfileProvider!.name.toString().split(" ").first,
          liveID: widget.liveID,
          config: widget.isHost
              ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
              : ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
        ),
      ),
    );
  }
}
