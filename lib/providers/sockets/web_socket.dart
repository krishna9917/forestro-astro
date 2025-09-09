import 'package:fore_astro_2/core/data/api/ApiRequest.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

const String socketHost = "http://143.244.130.192:4000";

class SocketService {
  static Future<IO.Socket> initSocket() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    IO.Socket socket = IO.io(socketHost, {
      'transports': ['websocket'],
      'extraHeaders': {
        'userid': prefs.getString("id").toString(),
        'type': 'astro',
        'token': prefs.getString("token").toString(),
      }
    });
    socket.connect();
    socket.onConnect((data) => {
          logger.f("socket is Connected",
              stackTrace: StackTrace.fromString(
                  "Socket================================================================"))
        });
    socket.onDisconnect((data) => {print("socket is Disconnect")});
    socket.on(
      "error",
      (data) => Logger().e(
        data,
        error: "Socket Error",
        time: DateTime.now(),
        stackTrace: StackTrace.empty,
      ),
    );
    socket.on(
      "apiError",
      (data) => Logger().e(
        data,
        error: "Socket Api Error",
        time: DateTime.now(),
        stackTrace: StackTrace.empty,
      ),
    );
    socket.onError(
      (data) => Logger().e(
        data,
        error: "Socket Error",
        time: DateTime.now(),
        stackTrace: StackTrace.empty,
      ),
    );
    return socket;
  }
}
