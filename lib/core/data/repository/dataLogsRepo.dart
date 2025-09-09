import 'package:dio/dio.dart';
import 'package:fore_astro_2/core/data/api/ApiRequest.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataLogsRepo {
// https://foreastro.bonwic.cloud/api/my-payment-history?astro_id=53
  static Future<Response> myPaymentHistory<T>() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");
      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/my-payment-history?astro_id=$id",
        method: ApiMethod.GET,
      );
      return await apiRequest.send<T>();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

// https://foreastro.bonwic.cloud/api/chat-log?astro_id=53
  static Future<Response> chatLogs<T>() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");
      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/chat-log?astro_id=$id",
        method: ApiMethod.GET,
      );
      return await apiRequest.send<T>();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

// https://foreastro.bonwic.cloud/api/call-log?astro_id=53
  static Future<Response> callLogs<T>() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");
      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/call-log?astro_id=$id",
        method: ApiMethod.GET,
      );

      return await apiRequest.send<T>();
    } catch (e) {
      print(e);
      rethrow;
    }
  }



// https://foreastro.bonwic.cloud/api/astrologer-payouts?astro_id=49
  static Future<Response> payoutsLogs<T>() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");
      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/astrologer-payouts?astro_id=$id",
        method: ApiMethod.GET,
      );
      return await apiRequest.send<T>();
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
