import 'package:dio/dio.dart';
import 'package:fore_astro_2/core/data/api/ApiRequest.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  // "https://foreastro.bonwic.cloud/api/astro-login"
  static Future<Response> astroLogin<T>(
      String phoneNo, String _version, String _buildNumber) async {
    print("hhhhhhhhhhhhh$_version$_buildNumber");
    try {
      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/astro-login",
        method: ApiMethod.POST,
        body: packFormData(
          {
            "phone": phoneNo,
            "version": "$_version $_buildNumber",
          },
        ),
      );
      print("apiRequest: ${apiRequest.body}");
      return await apiRequest.send<T>();
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> version<T>(
      String _version, String _buildNumber) async {
    print("hhhhhhhhhhhhh$_version$_buildNumber");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString("id");
    print("id: $id");
    try {
      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/astro-version-update",
        method: ApiMethod.POST,
        body: packFormData(
          {
            "astro_id": id,
            "version": "$_version $_buildNumber",
          },
        ),
      );
      print("apiRequest: ${apiRequest.body}");
      return await apiRequest.send<T>();
    } catch (e) {
      rethrow;
    }
  }

  // "https://foreastro.bonwic.cloud/api/astro-login"
  static Future<Response> astroVerifyOtp<T>(String astroId, String otp) async {
    try {
      ApiRequest apiRequest = ApiRequest("$apiUrl/login-verify-otp",
          method: ApiMethod.POST,
          body: packFormData(
            {"astro_id": astroId, "otp": otp},
          ));
      return await apiRequest.send<T>();
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> astroProfile<T>() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");
      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/astro-profile?astro_id=$id",
        method: ApiMethod.GET,
      );
      return await apiRequest.send<T>();
    } catch (e) {
      rethrow;
    }
  }

  // "https://foreastro.bonwic.cloud/api/astro-create-profile"
  static Future<Response> createProfile<T>(dynamic fromData) async {
    try {
      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/astro-create-profile",
        method: ApiMethod.POST,
        body: fromData,
      );
      return await apiRequest.send<T>();
    } catch (e) {
      rethrow;
    }
  }
}
