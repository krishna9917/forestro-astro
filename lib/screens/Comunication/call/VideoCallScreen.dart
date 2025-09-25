import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_astro_2/Components/RequestBox.dart';
import 'package:fore_astro_2/constants/ZegoKeys.dart';
import 'package:fore_astro_2/core/data/repository/communicationRepo.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:fore_astro_2/core/helper/helper.dart';
import 'package:fore_astro_2/providers/ComunicationProvider.dart';
import 'package:fore_astro_2/providers/UserProfileProvider.dart';
import 'package:fore_astro_2/providers/sessionProvider.dart';
import 'package:fore_astro_2/providers/sockets/socketProvider.dart';
import 'package:fore_astro_2/screens/Comunication/endSession/EndVideoSession.dart';
import 'package:fore_astro_2/screens/pages/kundli/KundliForm.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({
    Key? key,
    required this.callID,
    required this.userid,
    required this.communicationId,
    required this.user_wallet,
  }) : super(key: key);
  final String callID;
  final String userid;
  final String communicationId;
  final double user_wallet;

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  Timer? _timer;
  late int _remainingSeconds;
  bool _isSessionEnded = false;
  bool _isBeeping = false;
  final AudioPlayer _player = AudioPlayer();
  bool _isConnecting = true;
  bool _timerStarted = false;

  @override
  void initState() {
    final userProfile = context.read<UserProfileProvider>().userProfileModel;

    final chatRatePerMinute =
        double.tryParse(userProfile?.videoChargesPerMin?.toString() ?? '1') ??
            1.0;

    // Round down wallet to nearest divisible by per-minute charge
    double totalWallet = widget.user_wallet;
    double perMin = chatRatePerMinute;
    double usableWallet = (totalWallet ~/ perMin) * perMin; // floor to divisible
    _remainingSeconds = perMin > 0 ? ((usableWallet / perMin) * 60).toInt() : 0;

    // Correct session type for video
    context.read<SessionProvider>().newSession(RequestType.Video);
    requestToAccpted();
    super.initState();
  }

  void _startCountdownTimer() {
    _timer?.cancel();
    // Remove noisy logs
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_remainingSeconds > 60) {
        setState(() {
          _remainingSeconds--;
        });
        if (_remainingSeconds == 120 && !_isBeeping) {
          _isBeeping = true;
          await _playBeepSound();
          _isBeeping = false; // Reset beeping flag
        }
      } else if (_remainingSeconds == 60) {
        timer.cancel();
        // End session to match user app behavior
        context.read<SessionProvider>().closeSession();
        context.read<SocketProvider>().onWorkEnd();
        navigateme.pop();
        navigateme.pushAndRemoveUntil(
          routeMe(EndVideoSession(communicationId: widget.communicationId)),
          (Route<dynamic> route) => false,
        );
      }
    });
    _timerStarted = true;
  }

  Future<void> _playBeepSound() async {
    try {
      await _player.setAsset('assets/bg/beep.mp3');
      for (int i = 0; i < 3; i++) {
        await _player.play();
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } catch (e) {
      // Only log errors
      debugPrint('Audio play error: $e');
    }
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  requestToAccpted() async {
    try {
      await CommunicationRepo.acceptOrRejectRequest(
          communicationId: widget.communicationId, status: "accept");
      context.read<CommunicationProvider>().reloadComunication();
    } catch (e) {
      showToast(e.toString());
      context.read<SocketProvider>().closeSession(
            communicationId: widget.communicationId,
            userType: "user",
            senderId: widget.userid,
            requestType: "video",
            message: "Internal error On Astrologer Side. Try Again",
          );
    }
  }

  @override
  void dispose() {
    _player.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: Stack(
          children: [
            ZegoUIKitPrebuiltCall(
              appID: ZegoKeys.appID,
              appSign: ZegoKeys.appSign,
              userID: widget.userid,
              userName: context
                  .read<UserProfileProvider>()
                  .userProfileModel!
                  .name
                  .toString()
                  .split(' ')
                  .first,
              callID: widget.callID,
              // userID: widget.userid,
              // callID: widget.callID,
              // userName: context
              //     .read<UserProfileProvider>()
              //     .userProfileModel!
              //     .name
              //     .toString(),
              events: ZegoUIKitPrebuiltCallEvents(
                onError: (e) {
                  print("astro error{$e}");
                },
                room: ZegoCallRoomEvents(onTokenExpired: (e) {
                  print("astro error{$e}");
                }, onStateChanged: (e) {
                  print("astro error{$e}");
                  // When room state changes, remove connecting overlay
                  if (mounted && _isConnecting) {
                    setState(() {
                      _isConnecting = false;
                    });
                  }
                  if (!_timerStarted) {
                    _startCountdownTimer();
                  }
                }),
                user: ZegoCallUserEvents(
                  onEnter: (p) {
                    showToast(p.name.toString() + " join in call");
                    context
                        .read<SessionProvider>()
                        .newSession(RequestType.Video);
                    if (mounted) {
                      setState(() {
                        _isConnecting = false;
                      });
                    }
                    if (!_timerStarted) {
                      _startCountdownTimer();
                    }
                  },
                ),
                onCallEnd: (event, defaultAction) {
                  // Stop timer immediately on call end
                  _timer?.cancel();
                  _timerStarted = false;
                  showToast("Video Call End");
                  context.read<SocketProvider>().onWorkEnd();
                  navigateme.pop();
                  navigateme.pushAndRemoveUntil(
                    routeMe(EndVideoSession(
                        communicationId: widget.communicationId)),
                    (Route<dynamic> route) => false,
                  );
                  // navigateme.push(routeMe(const EndVideoSession()));
                },
              ),
              config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
                ..layout = ZegoLayout.pictureInPicture(),
            ),
            SafeArea(
              child: SizedBox(
                height: 60,
                child: AppBar(
                  leading: const SizedBox(),
                  backgroundColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  actions: [
                    IconButton(
                        onPressed: () {
                          navigateme.push(routeMe(KundliForm(
                            id: int.parse(widget.userid),
                          )));
                        },
                        icon: const Icon(
                          FontAwesomeIcons.info,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
            ),
            if (!_isConnecting && _timerStarted) SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 125, 122, 122),
                        Color.fromARGB(151, 234, 231, 227)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(2, 4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.timer_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formatTime(_remainingSeconds),
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_isConnecting)
              const SafeArea(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 12),
                      Text(
                        "Please wait, we are connecting...",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
