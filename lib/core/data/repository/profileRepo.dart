import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fore_astro_2/core/data/api/ApiRequest.dart';
import 'package:fore_astro_2/core/extensions/Text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../screens/splash/SplashScreen.dart';
import '../../helper/Navigate.dart';

class ProfileRepo {
  // "https://foreastro.bonwic.cloud/api/astro-profile?astro_id=35"
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

  // "https://foreastro.bonwic.cloud/api/astro-logout?astro_id=35"
  static Future<Response> astroLogout<T>() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");

      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/astro-logout?astro_id=$id",
        method: ApiMethod.GET,
      );
      return await apiRequest.send<T>();
    } catch (e) {
      navigateme.push(
        routeMe(
          const SplashScreen(),
        ),
      );
      rethrow;
    }
  }

  // "https://foreastro.bonwic.cloud/api/astro-personal-details"
  static Future<Response> updateAstroPersonalDetails<T>(
      {required String dob,
      required String borthPlace,
      required String city,
      required String adharId,
      required String panNumber,
      required String address,
      required String state,
      required String gender,
      required String pinCode
      }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");
      ApiRequest apiRequest = ApiRequest("$apiUrl/astro-personal-details",
          method: ApiMethod.POST,
          body: packFormData({
            'astro_id': id,
            'date_of_birth': dob,
            'gender': gender,
            'birth_place': borthPlace,
            'city': city,
            'adhar_id': adharId,
            'pan_number': panNumber,
            'state': state,
            'address': address,
            'pin_code': pinCode,
          }));
      return await apiRequest.send<T>();
    } catch (e) {
      rethrow;
    }
  }

  // "https://foreastro.bonwic.cloud/api/astro-professional-details"
  static Future<Response> updateAstroProfessionalDetails<T>(
      {required String experience,
      required String call_charges_per_min,
      required String chat_charges_per_min,
      required String video_charges_per_min,
      required String education,
      required String description,
      required String start_time_slot,
      required List languaage,
      required String end_time_slot}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");
      ApiRequest apiRequest = ApiRequest("$apiUrl/astro-professional-details",
          method: ApiMethod.POST,
          body: packFormData({
            'astro_id': id,
            'experience': experience,
            'languaage': jsonEncode(languaage),
            'call_charges_per_min': call_charges_per_min,
            'chat_charges_per_min': chat_charges_per_min,
            'education': education,
            'description': description,
            'start_time_slot': start_time_slot,
            'end_time_slot': end_time_slot,
            'video_charges_per_min': video_charges_per_min,
          }));
      return await apiRequest.send<T>();
    } catch (e) {
      rethrow;
    }
  }

  // https://foreastro.bonwic.cloud/api/astro-profile-image-update
  static Future<Response> astroUpdateProfileImage<T>(dynamic image) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");

      ApiRequest apiRequest = ApiRequest("$apiUrl/astro-profile-image-update",
          method: ApiMethod.POST,
          body: packFormData({"astro_id": id, "profile_img": image}));
      return await apiRequest.send<T>();
    } catch (e) {
      rethrow;
    }
  }

  //https://foreastro.bonwic.cloud/api/astro-profile-update
  static Future<Response> astroUpdateProfileInfo<T>(
      {required String name,
      required String email,
      required String specialization,
      required String description}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");

      ApiRequest apiRequest = ApiRequest("$apiUrl/astro-profile-update",
          method: ApiMethod.POST,
          body: packFormData({
            "astro_id": id,
            "name": name,
            "email": email,
            "specialization": specialization,
            "description": description,
          }));
      return await apiRequest.send<T>();
    } catch (e) {
      rethrow;
    }
  }

// "https://foreastro.bonwic.cloud/api/astro-certificate-delete"
  static Future<Response> astroCertifyDelete<T>(dynamic id) async {
    try {
      ApiRequest apiRequest = ApiRequest("$apiUrl/astro-certificate-delete",
          method: ApiMethod.POST,
          body: packFormData({
            "certificate_id": id,
          }));
      return await apiRequest.send<T>();
    } catch (e) {
      rethrow;
    }
  }

// "https://foreastro.bonwic.cloud/api/update-certificates"
  static Future<Response> uploadCertificate<T>(MultipartFile file) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");

      ApiRequest apiRequest = ApiRequest("$apiUrl/update-certificates",
          method: ApiMethod.POST,
          body: packFormData({
            "astro_id": id,
            "certifications": file,
          }));
      return await apiRequest.send<T>();
    } catch (e) {
      rethrow;
    }
  }

// https://foreastro.bonwic.cloud/api/mark-online-or-offline
  static Future<Response> setAstroOnlineOROffline<T>(bool status) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");

      ApiRequest apiRequest = ApiRequest("$apiUrl/mark-online-or-offline",
          method: ApiMethod.POST,
          body: packFormData({
            "astro_id": id,
            "status": status ? "online" : "offline",
          }));
      return await apiRequest.send<T>();
    } catch (e) {
      rethrow;
    }
  }

// https://foreastro.bonwic.cloud/api/astro-review-list?astro_id=53
  static Future<Response> myReviews<T>() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");
      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/astro-review-list?astro_id=$id",
        method: ApiMethod.GET,
      );
      return await apiRequest.send<T>();
    } catch (e) {
      rethrow;
    }
  }

// https://foreastro.bonwic.cloud/api/raise-an-issue
  static Future<Response> submitIssue<T>(
      {required String type, required String message}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");
      ApiRequest apiRequest = ApiRequest("$apiUrl/raise-an-issue",
          method: ApiMethod.POST,
          body:
              packFormData({"astro_id": id, "type": type, "message": message}));
      return await apiRequest.send<T>();
    } catch (e) {
      rethrow;
    }
  }

// https://foreastro.bonwic.cloud/api/user-profile-details?user_id=6
  static Future<Response> getClient<T>(String id) async {
    try {
      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/user-profile-details?user_id=$id",
        method: ApiMethod.GET,
      );
      return await apiRequest.send<T>();
    } catch (e) {
      rethrow;
    }
  }

// https://foreastro.bonwic.cloud/api/my-follower?astro_id=53
  static Future<Response> getFollowers<T>() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");
      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/my-follower?astro_id=$id",
        method: ApiMethod.GET,
      );
      return await apiRequest.send<T>();
    } catch (e) {
      rethrow;
    }
  }

  // {{baseUrl}}/astrologer-boost
  static Future<Response> boostProfile<T>({required String amount}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");
      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/astrologer-boost",
        method: ApiMethod.POST,
        body: packFormData({
          "astro_id": id,
          "amount": amount,
        }),
      );
      return await apiRequest.send<T>();
    } catch (e) {
      rethrow;
    }
  }

// https://foreastro.bonwic.cloud/api/astro-review-list?astro_id=53
  static Future<Response> getUser<T>(String id) async {
    try {
      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/user-profile-data?user_id=$id",
        method: ApiMethod.GET,
      );
      return await apiRequest.send<T>();
    } catch (e) {
      rethrow;
    }
  }
}
