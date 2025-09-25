import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_astro_2/Components/RequestBox.dart';
import 'package:fore_astro_2/constants/Assets.dart';
import 'package:fore_astro_2/core/data/model/UserProfileModel.dart';
import 'package:fore_astro_2/core/data/repository/communicationRepo.dart';
import 'package:fore_astro_2/core/extensions/window.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:fore_astro_2/core/utils/AlertHelper.dart';
import 'package:fore_astro_2/providers/ComunicationProvider.dart';
import 'package:fore_astro_2/providers/UserProfileProvider.dart';
import 'package:fore_astro_2/providers/sessionProvider.dart';
import 'package:fore_astro_2/providers/sockets/socketProvider.dart';
import 'package:fore_astro_2/screens/Comunication/endSession/EndChatSession.dart';
import 'package:fore_astro_2/screens/main/ProfileUpdate/Preview/PreviewDocsScreen.dart';
import 'package:fore_astro_2/screens/pages/kundli/KundliForm.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class ChatScreen extends StatefulWidget {
  final String id;
  final String userId;
  final String communicationId;
  final double user_wallet;

  const ChatScreen({
    super.key,
    required this.id,
    required this.communicationId,
    required this.userId,
    required this.user_wallet,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Timer? _timer;
  int remainingSeconds = 0;
  int _remainingSeconds = 0;
  Timer? _sessionEndTimer;
  final bool _isSessionEnded = false;
  bool _isBeeping = false;
  final AudioPlayer _player = AudioPlayer();
  bool _zimReady = false;
  late final ValueNotifier<int> _remainingSecondsNotifier =
      ValueNotifier<int>(_remainingSeconds);

  @override
  void initState() {
    super.initState();
    final userProfile = context.read<UserProfileProvider>().userProfileModel;
    final chatRatePerMinute =
        double.tryParse(userProfile?.chatChargesPerMin?.toString() ?? '1') ??
            1.0;

    // Match user app: use only full divisible minutes
    if (chatRatePerMinute > 0) {
      final double perMin = chatRatePerMinute;
      final double usableWallet = (widget.user_wallet ~/ perMin) * perMin;
      _remainingSeconds = ((usableWallet / perMin) * 60).toInt();
    } else {
      _remainingSeconds = 0;
    }

    context.read<SessionProvider>().newSession(RequestType.Chat);
    requestToAccpted();
    _startCountdownTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatzegocloud();
    });
  }

  void _startCountdownTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        _remainingSecondsNotifier.value = _remainingSeconds;
        if (_remainingSeconds == 120 && !_isBeeping) {
          _isBeeping = true;
          await _playBeepSound();
          _isBeeping = false;
        }
      } else if (_remainingSeconds == 0) {
        // Stop countdown and end session at 0s left
        timer.cancel();
        onUserEndChat();
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
      print('Audio play error: $e');
    }
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _player.dispose();
    _timer?.cancel();
    _sessionEndTimer?.cancel();
    _remainingSecondsNotifier.dispose();
    super.dispose();
  }

  requestToAccpted() async {
    try {
      await CommunicationRepo.acceptOrRejectRequest(
        communicationId: widget.communicationId,
        status: "accept",
      );
      print("Chat request accepted.");
      context.read<CommunicationProvider>().reloadComunication();
    } catch (e) {
      context.read<SocketProvider>().closeSession(
            communicationId: widget.communicationId,
            userType: "user",
            senderId: widget.id,
            requestType: "chat",
            message: "Internal error on astrologer side. Try again.",
          );
    }
  }

  Future<void> chatzegocloud() async {
    final prefs = await SharedPreferences.getInstance();
    final astroId = prefs.getString("id");
    final String targetId = "${astroId}-astro";
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await ZIMKit().connectUser(
          id: targetId,
          name: "Astrologer",
        );
        if (mounted) {
          setState(() {
            _zimReady = true;
          });
        }
      } catch (e) {
        // ignore and keep loader; ZIM will handle state
      }
    });
  }

  notResendTime() async {
    _sessionEndTimer?.cancel();
    _sessionEndTimer = Timer.periodic(const Duration(minutes: 2), (timer) {
      if (!_isSessionEnded) {
        onUserEndChat();
      }
    });
  }

  onUserEndChat() async {
    context.read<SocketProvider>().closeSession(
          senderId: widget.userId,
          userType: "user",
          requestType: "chat",
          message: 'Astrologer ended chat session.',
          communicationId: widget.communicationId,
        );
    _timer?.cancel();
    _sessionEndTimer?.cancel();
    context.read<SessionProvider>().closeSession();
    context.read<SocketProvider>().onWorkEnd();
    navigateme.pop();
    navigateme.pushAndRemoveUntil(
      routeMe(EndChatSession(communicationId: widget.communicationId)),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.id);
    if (!_zimReady) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text(
                "Please wait, we are connecting...",
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      );
    }
    return WillPopScope(
      onWillPop: () async {
        _timer?.cancel();
        showAlertPopup(
          context,
          title: "Are you Sure",
          text: "Sure you want to close the chat session?",
          showCancelBtn: true,
          confirmBtnText: "Yes",
          type: QuickAlertType.warning,
          onConfirmBtnTap: () {
            onUserEndChat();
          },
        );
        return false;
      },
      child: Stack(
        children: [
          ZIMKitMessageListPage(
            key: ValueKey('chat-${widget.id}'),
            showPickMediaButton: true,
            showMoreButton: false,
            showPickFileButton: false,
            messageListBackgroundBuilder: (context, defaultWidget) {
              return Image.asset(
                AssetsPath.chatBgSvg,
                width: context.windowWidth,
                height: context.windowHeight,
                fit: BoxFit.cover,
              );
            },
            appBarBuilder: (context, defaultAppBar) {
              return AppBar(
                title: defaultAppBar.title,
                actions: [
                  IconButton(
                    onPressed: () {
                      navigateme.push(
                        routeMe(
                          KundliForm(
                            id: int.parse(widget.userId.split("-")[0]),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(FontAwesomeIcons.info),
                  ),
                ],
              );
            },
            messageItemBuilder: (context, message, defaultWidget) {
              if (message.type == ZIMMessageType.image) {
                return GestureDetector(
                  onTap: () {
                    navigateme.push(
                      routeMe(
                        PreviewScreen(
                          isImage: true,
                          certification: Certifications(
                            certificate: message.imageContent!.fileDownloadUrl,
                            certificateId:
                                DateTime.now().microsecondsSinceEpoch,
                            fileSize: message.imageContent!.fileSize.toString(),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      defaultWidget,
                      Container(
                        width: context.windowWidth,
                        height: 170,
                        color: Colors.transparent,
                      ),
                    ],
                  ),
                );
              }
              return defaultWidget;
            },
            onMessageSent: (e) {
              print(e.textContent);
              notResendTime();
            },
            inputDecoration: const InputDecoration(
              border: InputBorder.none,
              errorBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 0),
            ),
            // Use peer user ID for ZIM peer conversation, not DB/call id
            conversationID: widget.id,
            conversationType: ZIMConversationType.peer,
          ),
          // Removed small duplicate countdown to avoid two timers
          Positioned(
            top: 5,
            right: 50,
            child: SafeArea(
              child: Container(
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
                    ValueListenableBuilder<int>(
                      valueListenable: _remainingSecondsNotifier,
                      builder: (context, value, _) => Text(
                        formatTime(value),
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
