import 'package:flutter/material.dart';
import 'package:fore_astro_2/Components/RequestBox.dart';
import 'package:fore_astro_2/core/data/model/CommunicationModel.dart';
import 'package:fore_astro_2/core/data/repository/profileRepo.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:fore_astro_2/core/helper/helper.dart';
import 'package:fore_astro_2/core/pushNotification/SnackBar/RequestSnackbar.dart';
import 'package:fore_astro_2/core/utils/AlertHelper.dart';
import 'package:fore_astro_2/providers/ComunicationProvider.dart';
import 'package:fore_astro_2/providers/sockets/web_socket.dart';
import 'package:fore_astro_2/screens/Comunication/Chat/ChatScreen.dart';
import 'package:fore_astro_2/screens/Comunication/call/AudioChatScreen.dart';
import 'package:fore_astro_2/screens/Comunication/call/VideoCallScreen.dart';
import 'package:fore_astro_2/screens/Comunication/endSession/EndChatSession.dart';
import 'package:fore_astro_2/screens/auth/LoginScreen.dart';
import 'package:logger/logger.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:just_audio/just_audio.dart';

RequestType getRequestType(String type) {
  switch (type) {
    case "chat":
      return RequestType.Chat;
    case "audio":
      return RequestType.Audio;
    case "video":
      return RequestType.Video;
    default:
      return RequestType.None;
  }
}

class SocketProvider with ChangeNotifier {
  final CommunicationProvider communicationProvider;
  AudioPlayer player = AudioPlayer();

  SocketProvider({required this.communicationProvider});

  Map? _workdata;

  bool _iAmWorkScreen = false;
  bool _isWettingAlertOpen = false;
  IO.Socket? _socket;

  IO.Socket? get socket => _socket;

  bool? get socketConnected => _socket?.connected;

  bool get iAmWorkScreen => _iAmWorkScreen;

  bool get isWettingAlertOpen => _isWettingAlertOpen;

  Map? get workdata => _workdata;
  double wallet = 0.0;

  Future<IO.Socket?> initSocketConnection() async {
    _socket = await SocketService.initSocket();
    notifyListeners();
    return _socket;
  }

  addSocketListeners() {
    // socket?.on('startSession', (data) {
    //   print("Start session data received: $data");
    // });
    socket?.on('request', (data) async {
      var getwallet = data['data']['user_wallet'];
      wallet = double.tryParse(getwallet.toString()) ?? 0.0;
      Logger().t(data,
          stackTrace: StackTrace.fromString("New Request From Socket"));
      print("data===============$data");
      if (iAmWorkScreen == false) {
        final duration = await player.setAsset('assets/alert.mp3');
        player.play();
        snackbarKey.currentState?.hideCurrentSnackBar();
        snackbarKey.currentState?.showSnackBar(
          SnackBarBox(
              requestType: getRequestType(data['requestType']),
              name: data['data']['name'],
              image: data['data']['profile_pic'],
              type: data['requestType'],
              user_wallet: data['data']['user_wallet'],
              onTap: () {
                player.stop();
              }),
        );
      }
      communicationProvider.reloadComunication();
    });

    socket?.on("wetting", (data) {
      player.stop();
      print("wallet===============$data");
      // if (_iAmWorkScreen) {
      //   socket?.emit("decline", data);
      //   return;
      // }

      // Prevent multiple alerts from opening
      if (_isWettingAlertOpen) {
        print("Wetting alert already open, ignoring duplicate event");
        return;
      }

      _isWettingAlertOpen = true;
      print("walletwetting===============$data");
      showAlertPopup(
        navigate.currentContext!,
        title: "Waiting For Confirmation",
        text: "${data['data']['name']} Send Confirm Request",
        type: QuickAlertType.loading,
        showCancelBtn: true,
        disableBackBtn: true,
        barrierDismissible: true,
        cancelBtnText: "Close",
        onCancelBtnTap: () {
          _isWettingAlertOpen = false;
          socket?.emit("decline", data);
          navigateme.pop();
        },
      );
    });

    socket?.on("wettingDecline", (data) {
      print("=========================$data");
      player.stop();
      print("Reject");
      // if (!iAmWorkScreen) {
      //   if (navigateme.canPop()) {
      //     // for close popup
      //     navigateme.pop();
      //   }
      // }
      _isWettingAlertOpen = false;
      showToast("Request Cancel");
    });

    socket?.on('openSession', (data) async {
      print("emiitdatauser${data}");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");

      // Logger().t(data,
      //     stackTrace: StackTrace.fromString("openSession From Socket"));
      print("dataopen===============$data");

      if (iAmWorkScreen) {
        socket?.emit("userBusy", {
          'userId': id.toString(),
          'userType': 'astro',
          'message': 'fdgdsfdsfdsf',
          'requestType': data['requestType'],
          'data': data['data'],
        });
        return false;
      } else {
        _iAmWorkScreen = true;
        _workdata = data;
        communicationProvider.nextSlots();
        notifyListeners();
      }
      snackbarKey.currentState?.hideCurrentSnackBar();
      if (navigateme.canPop()) {
        // for close Wetting popup
        navigateme.pop();
      }
      _isWettingAlertOpen = false;
      if (data['requestType'] == "chat") {
        print("data_for_chat$data");
        navigateme.push(routeMe(ChatScreen(
          id: "${data['userId']}-user",
          communicationId: data['data']["id"].toString(),
          userId: data['userId'],
          user_wallet: wallet,
        )));
      } else if (data['requestType'] == "video") {
        navigateme.push(
          routeMe(
            VideoCallScreen(
              communicationId: data['data']['id'].toString(),
              callID: data['data']['communication_id'],
              userid: data['userId'],
              user_wallet: wallet,
            ),
          ),
        );
      } else if (data['requestType'] == "audio") {
        navigateme.push(
          routeMe(
            AudioCallScreen(
              communicationId: data['data']['id'].toString(),
              callID: data['data']['communication_id'],
              userid: data['userId'],
              user_wallet: wallet,
            ),
          ),
        );
      } else {
        _iAmWorkScreen = false;
        notifyListeners();
        showToast("Unknown Request Type");
      }
    });
    socket?.on('startSession', (data) {
      print("Start session data received: $data");
    });
    socket?.on('busy', (data) {
      Logger().t(data, stackTrace: StackTrace.fromString("busy From Socket"));
      showToast("Sorry, User is Busy with other Astrologer.Please Try Later");
    });
// Handle socket disconnection
    socket?.on('disconnect', (data) => {endLiveSession()});
    socket?.on("closeSession", (data) {
      print("dattttttttttttt=============$data");
      var communicationId = data['data']['communication_id'];
      print("comunicayion===================$communicationId");

      print("colose_sesiondatattttttttt$data");
      Logger().t(data,
          stackTrace: StackTrace.fromString("closeSession From Socket"));
      if (iAmWorkScreen) {
        _workdata = null;
        _iAmWorkScreen = false;
        notifyListeners();

        navigateme.popUntil((route) => route.isFirst);
        if (data['requestType'] == "chat") {
          navigateme.pushAndRemoveUntil(
            routeMe(EndChatSession(communicationId: communicationId)),
            (Route<dynamic> route) => false,
          );
          // navigateme.push(routeMe(const EndChatSession()));
        }
        // if (data['requestType'] == "audio") {
        //   navigateme.pushAndRemoveUntil(
        //     routeMe(const EndAudioSession()),
        //     (Route<dynamic> route) => false,
        //   );
        // }
      }
    });
  }

  // void handleSessionClosure(String requestType) {
  //   switch (requestType) {
  //     case "chat":
  //       navigateme.push(routeMe(const EndChatSession()));
  //       break;
  //     case "audio":
  //       navigateme.push(routeMe(const EndAudioSession()));
  //       break;
  //     case "video":
  //       navigateme.push(routeMe(const EndVideoSession()));
  //       break;
  //     default:
  //       Logger().w("Unknown session type: $requestType");
  //   }
  // }

  void onWorkEnd() {
    _iAmWorkScreen = false;
    _workdata = null;
    _isWettingAlertOpen = false;
    notifyListeners();
  }

  void acceptORrejectRequest(
    String emit, {
    required String senderId,
    required String requestType,
    required String communicationId,
    required String status,
    required CommunicationModel communicationModel,
    required Map data,
  }) {
    print('comunucationnnnnnnnnnn: $data');
    if (status.toLowerCase() == "reject") {
      print(communicationId);
      if (requestType == "chat") {
        communicationProvider.removeFormChat(int.parse(communicationId));
      } else {
        print("test");
        communicationProvider.removeFormCall(int.parse(communicationId));
      }
      communicationProvider.nextSlots();
    }

    socket?.emit(emit, {
      'userId': senderId,
      'userType': 'user',
      'requestType': requestType,
      'data': {
        ...communicationModel.toJson(),
        "status": status,
        ...data,
      },
    });

    print('dataaacpect===============${{
      'userId': senderId,
      'userType': 'user',
      'requestType': requestType,
      'data': {
        ...communicationModel.toJson(),
        "status": status,
        ...data,
      },
    }}');
  }

  void closeSession(
      {required String senderId,
      required String userType,
      required String requestType,
      required String message,
      required String communicationId}) {
    socket?.emit("endSession", {
      'userId': senderId,
      'userType': 'user',
      'requestType': requestType,
      'message': message,
      'data': {
        "communication_id": communicationId,
        'userId': senderId,
      },
    });
  }

// live start
  startLiveSession(
      {required int userId,
      required String name,
      required String profile,
      required double chegesPerMin,
      required String liveId,
      required Map data}) {
    socket?.emit("startLiveSession", {
      "userId": userId,
      "liveId": liveId,
      "name": name,
      "charges": chegesPerMin / 60,
      "profile": profile,
      "data": data
    });
    _iAmWorkScreen = true;
    _workdata = data;
    notifyListeners();
  }

// live end
  endLiveSession() {
    socket?.disconnect();
    socket?.emit("endLiveSession");

    onWorkEnd();

    // navigateme.popUntil((route) => route.isFirst);
  }

  Future logoutUse() async {
    await logoutFromDB();
    socket?.disconnect();
    _isWettingAlertOpen = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    navigateme.popUntil((route) => route.isFirst);
    navigateme.pushReplacement(routeMe(const LoginScreen()));
  }

  logoutFromDB() async {
    try {
      await ProfileRepo.astroLogout();
    } catch (e) {
      print(e);
    }
  }
}
