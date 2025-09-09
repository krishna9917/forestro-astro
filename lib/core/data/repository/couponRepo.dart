import 'package:dio/dio.dart';
import 'package:fore_astro_2/core/data/api/ApiRequest.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CouponRepo {
  // https://foreastro.bonwic.cloud/api/list-coupon?astro_id=51
  static Future<Response> getCoupons<T>() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");
      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/list-coupon?astro_id=$id",
        method: ApiMethod.GET,
      );
      return await apiRequest.send<T>();
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> activeCoupon(
      {required int couponId, required String type}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");
      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/coupon-active",
        method: ApiMethod.POST,
        body:
            packFormData({"astro_id": id, "coupon_id": couponId, "type": type}),
      );
      return await apiRequest.send();
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> deActiveCoupon({required int couponId}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");
      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/coupon-de-active",
        method: ApiMethod.POST,
        body: packFormData({"astro_id": id, "coupon_id": couponId}),
      );
      return await apiRequest.send();
    } catch (e) {
      rethrow;
    }
  }
}
