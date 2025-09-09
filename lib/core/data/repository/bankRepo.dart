import 'package:dio/dio.dart';
import 'package:fore_astro_2/core/data/api/ApiRequest.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BankRepo {
  // "https://foreastro.bonwic.cloud/api/astro-banks?astro_id=44"
  static Future<Response> loadBankAccounts<T>() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");

      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/astro-banks?astro_id=$id",
        method: ApiMethod.GET,
      );
      return await apiRequest.send<T>();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // "https://foreastro.bonwic.cloud/api/astro-add-bank"
  static Future<Response> addNewBank<T>({
    required String name,
    required String accountNumber,
    required String ifsc,
    String status = "0",
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");
      ApiRequest apiRequest = ApiRequest("$apiUrl/astro-add-bank",
          method: ApiMethod.POST,
          body: packFormData({
            'astro_id': id,
            'name': name,
            'account_number': accountNumber,
            'ifsc': ifsc,
            'status': status,
          }));
      return await apiRequest.send<T>();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // "https://foreastro.bonwic.cloud/api/astro-bank-delete"
  static Future<Response> deleteBankAccounts<T>(banKId) async {
    try {
      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/astro-bank-delete",
        method: ApiMethod.POST,
        body: packFormData(
          {"bank_id": banKId},
        ),
      );
      return await apiRequest.send<T>();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // "https://foreastro.bonwic.cloud/api/astro-update-bank"
  static Future<Response> updateNewBank<T>({
    required String bankid,
    required String name,
    required String accountNumber,
    required String ifsc,
    String status = "0",
  }) async {
    try {
      ApiRequest apiRequest = ApiRequest("$apiUrl/astro-update-bank",
          method: ApiMethod.POST,
          body: packFormData({
            'bank_id': bankid,
            'name': name,
            'account_number': accountNumber,
            'ifsc': ifsc,
            'status': status,
          }));
      return await apiRequest.send<T>();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // "https://foreastro.bonwic.cloud/api/astro-bank-primary"
  static Future<Response> setPrimaryBankAccounts<T>(bankId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");

      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/astro-bank-primary",
        method: ApiMethod.POST,
        body: packFormData(
          {
            "astro_id": id,
            "bank_id": bankId,
          },
        ),
      );
      return await apiRequest.send<T>();
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
