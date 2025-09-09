import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fore_astro_2/Components/AccptedRequest.dart';
import 'package:fore_astro_2/Components/RequestBox.dart';
import 'package:fore_astro_2/core/data/repository/communicationRepo.dart';
import 'package:fore_astro_2/core/extensions/Text.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:fore_astro_2/providers/UserProfileProvider.dart';
import 'package:fore_astro_2/providers/sessionProvider.dart';
import 'package:fore_astro_2/screens/main/HomeTabScreen.dart';
import 'package:provider/provider.dart';

class EndChatSession extends StatefulWidget {
  final String communicationId;
  const EndChatSession({super.key, required this.communicationId});

  @override
  State<EndChatSession> createState() => _EndChatSessionState();
}

class _EndChatSessionState extends State<EndChatSession> {
  @override
  void initState() {
    // context.read<SessionProvider>().closeSession();
    // context.watch<UserProfileProvider>().userProfileModel?.wallet;
    couminicationupdate();
    Timer(const Duration(seconds: 4), () {
      navigateme.pushAndRemoveUntil(
        routeMe(HomeTabScreen()),
        (Route<dynamic> route) => false,
      );
    });
    super.initState();
  }

  couminicationupdate() async {
    try {
      // Convert seconds to HH:MM:SS format
      final int totalSeconds = context.read<SessionProvider>().sec;
      final String formattedTime = Duration(seconds: totalSeconds)
          .toString()
          .split('.')
          .first; // Gets HH:MM:SS format
      print("hhhhhhhhhhhhhhhhhhhhhh==========$formattedTime");
      await CommunicationRepo.communicationchargesupdate(
        communicationId: widget.communicationId,
        time: formattedTime,
      );
    } catch (e) {
      // Handle the error
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("End Chat Session".toUpperCase()),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Center(
                child: requestImage(RequestType.Chat, width: 80, height: 80),
              ),
              const SizedBox(height: 20),
              Text(
                "${context.read<SessionProvider>().sec ~/ 60} Min ${context.read<SessionProvider>().sec % 60} Sec",
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Credit Amount : ${(context.read<SessionProvider>().sec.toMinutes() * int.parse(context.read<UserProfileProvider>().userProfileModel?.callChargesPerMin ?? "0")).toStringAsFixed(2)}",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
