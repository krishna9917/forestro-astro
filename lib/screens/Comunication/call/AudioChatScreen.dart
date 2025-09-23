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
import 'package:fore_astro_2/screens/Comunication/endSession/EndAudioSession.dart';
import 'package:fore_astro_2/screens/pages/kundli/KundliForm.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class AudioCallScreen extends StatefulWidget {
  const AudioCallScreen({
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
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen> {
  Timer? _timer;
  late int _remainingSeconds;
  bool _isSessionEnded = false;
  bool _isBeeping = false;
  final AudioPlayer _player = AudioPlayer();
  bool _isTimerStarted = false;

  @override
  void initState() {
    final userProfile = context.read<UserProfileProvider>().userProfileModel;

    final chatRatePerMinute =
        double.tryParse(userProfile?.callChargesPerMin?.toString() ?? '1') ??
            1.0;

    // _remainingSeconds = chatRatePerMinute > 0
    //     ? (widget.user_wallet / chatRatePerMinute * 60).toInt()
    //     : 0;

    // Round down wallet to nearest divisible by per-minute charge
    double totalWallet = widget.user_wallet;
    double perMin = chatRatePerMinute;
    double usableWallet = (totalWallet ~/ perMin) * perMin; // floor to divisible
    _remainingSeconds = perMin > 0 ? ((usableWallet / perMin) * 60).toInt() : 0;

    // Correct session type for audio
    context.read<SessionProvider>().newSession(RequestType.Audio);
    requestToAccpted();

    super.initState();
  }

  void _startCountdownTimer() {
    _timer?.cancel();
    // Remove noisy logs
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
          // keep UI only
        });

        if (_remainingSeconds == 120 && !_isBeeping) {
          _isBeeping = true;
          await _playBeepSound();
          _isBeeping = false;
        }
      } else {
        timer.cancel();
        // end
      }
    });
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

  Future<void> _endCallSession() async {
    showToast("Audio Call End");
    context.read<SessionProvider>().closeSession();
    context.read<SocketProvider>().onWorkEnd();
    navigateme.pop();
    navigateme.pushAndRemoveUntil(
      routeMe(EndAudioSession(communicationId: widget.communicationId)),
      (Route<dynamic> route) => false,
    );
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
            requestType: "audio",
            message: "Internal error On Astrologer Side. Try Again",
          );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _player.dispose();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _timer?.cancel();
    } else if (state == AppLifecycleState.resumed) {
      _startCountdownTimer();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          ZegoUIKitPrebuiltCall(
              appID: 844833851,
              appSign:
                  '136a48b12cd722234938f6d8613362686b991c1e50784524851803fb7fdab1ab',
              userID: widget.userid,
              userName: context
                  .read<UserProfileProvider>()
                  .userProfileModel!
                  .name
                  .toString()
                  .split(' ')
                  .first,
              events: ZegoUIKitPrebuiltCallEvents(
                room: ZegoCallRoomEvents(
                  onStateChanged: (e) {
                    if (!_isTimerStarted) {
                      _startCountdownTimer();
                      _isTimerStarted = true;
                    }
                  },
                ),
                user: ZegoCallUserEvents(
                  onEnter: (p) {
                    showToast(p.name.toString() + " join in call");
                    context
                        .read<SessionProvider>()
                        .newSession(RequestType.Audio);
                    if (!_isTimerStarted) {
                      _startCountdownTimer();
                      _isTimerStarted = true;
                    }
                  },
                ),
                onCallEnd: (event, defaultAction) async {
                  showToast("Audio Call End");
                  // await _endCallSession();
                  context.read<SessionProvider>().closeSession();
                  context.read<SocketProvider>().onWorkEnd();
                  navigateme.pop();
                  navigateme.pushAndRemoveUntil(
                    routeMe(EndAudioSession(
                        communicationId: widget.communicationId)),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
              callID: widget.callID,
              config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()),
          Center(child: Image.asset("assets/call_logo.jpg")),
          // Container(
          //   decoration: const BoxDecoration(
          //     // color: Colors.white,
          //     image: DecorationImage(
          //       image: AssetImage("assets/call_logo.jpg"),
          //       // fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 59,
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
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        ],
      ),
    );
  }
}
