import 'package:dio/dio.dart';

import 'package:fore_astro_2/core/data/api/ApiRequest.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../screens/splash/SplashScreen.dart';
import '../../helper/Navigate.dart';

class CommunicationRepo {
  // "https://foreastro.bonwic.cloud/api/get-communication-call-request?astro_id=46"
  static Future<Response> loadChatCallRequest<T>() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");

      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/get-communication-request?astro_id=$id",
        method: ApiMethod.GET,
      );
      return await apiRequest.send<T>();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // "https://foreastro.bonwic.cloud/api/all-communication-request?astro_id=46"
  static Future<Response> loadAllChatCallRequest<T>() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");

      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/all-communication-request?astro_id=$id",
        method: ApiMethod.GET,
      );
      return await apiRequest.send<T>();
    } catch (e) {
      print("Error in loadAllChatCallRequest: $e");

      // Show error toast
      navigateme.push(
        routeMe(
          const SplashScreen(),
        ),
      );

      // Restart the app after a delay
      Future.delayed(Duration(seconds: 2), () {});
      rethrow;
    }
  }

// https://foreastro.bonwic.cloud/api/update-communication-status
  static Future<Response> acceptOrRejectRequest<T>(
      {required String communicationId, required String status}) async {
    try {
      ApiRequest apiRequest = ApiRequest("$apiUrl/update-communication-status",
          method: ApiMethod.POST,
          body: packFormData({
            "communication_id": communicationId,
            "status": status,
          }));
      return await apiRequest.send<T>();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future<Response> communicationchargesupdate<T>(
      {required String communicationId, required String time}) async {
    try {
      ApiRequest apiRequest = ApiRequest("$apiUrl/communication-charges-update",
          method: ApiMethod.POST,
          body: packFormData({
            "communication_id": communicationId,
            "time": time,
          }));
      print('apiRequest.body${apiRequest.body}');
      return await apiRequest.send<T>();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

// https://foreastro.bonwic.cloud/api/todat-communication-log?astro_id=53
  static Future<Response> todayCommunicationLogs<T>() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");
      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/todat-communication-log?astro_id=$id",
        method: ApiMethod.GET,
      );
      return await apiRequest.send<T>();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

// https://foreastro.bonwic.cloud/api/filter-pending-user?astro_id=48&user_name=s
  static Future<Response> searchRequests<T>(String name) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");
      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/filter-pending-user?astro_id=$id&user_name=$name",
        method: ApiMethod.GET,
      );
      return await apiRequest.send<T>();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

// https://foreastro.bonwic.cloud/api/astrologer-communicatin-all-data-count?astro_id=51
  static Future<Response> totalReport<T>() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");
      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/astrologer-communicatin-all-data-count?astro_id=$id",
        method: ApiMethod.GET,
      );
      return await apiRequest.send<T>();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // https://foreastro.bonwic.cloud/api/astro-ramedy-create
  static Future<Response> astroRamedyCreate<T>(String text) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");
      ApiRequest apiRequest = ApiRequest("$apiUrl/astro-ramedy-create",
          method: ApiMethod.POST,
          body: packFormData({
            "astro_id": id,
            "description": text,
          }));
      return await apiRequest.send<T>();
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
