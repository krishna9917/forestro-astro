import 'package:dio/dio.dart';
import 'package:fore_astro_2/core/data/api/ApiRequest.dart';
import 'package:fore_astro_2/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationRepo {
  static Future<Response> setToken<T>() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");
      String? nToken = await firebaseMessaging.getToken();
      print(nToken);
      ApiRequest apiRequest = ApiRequest("$apiUrl/astro-notifaction-token",
          method: ApiMethod.POST,
          body: packFormData({
            "notifaction_token": nToken,
            "astro_id": id,
          }));
      return await apiRequest.send<T>();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future<Response> sendsignal<T>() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");
      String? sToken = prefs.getString("externalId");
      print("sToken=======$sToken");
      ApiRequest apiRequest =
          ApiRequest("$apiUrl/astro-signal-notifaction-send",
              method: ApiMethod.POST,
              body: packFormData({
                "astro_id": id,
                "signal_id": sToken.toString(),
              }));
      return await apiRequest.send<T>();
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
