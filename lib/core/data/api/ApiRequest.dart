import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

Logger logger = Logger();
String apiUrl = "https://foreastro.technovaedge.in/api";
// String apiUrl = "https://foreastro.com/api";
String apiKundliUrl = "https://api.vedicastroapi.com/v3-json";

const String toastError = "Something Went Wrong!";

class ApiMethod {
  static const String GET = "GET";
  static const String POST = "POST";
  static const String PUT = "PUT";
  static const String PATCH = "PATCH";
  static const String DELETE = "DELETE";
}

FormData packFormData(data) {
  return FormData.fromMap(data);
}

Future<MultipartFile> addFormFile(String filePath, {String? filename}) async {
  return await MultipartFile.fromFile(filePath, filename: filename);
}

class ApiRequest {
  final String url;
  String? method;
  var body;
  bool showLogs;
  Options? options;
  final Dio dio = Dio();

  ApiRequest(this.url,
      {this.method, this.body, this.options, this.showLogs = kDebugMode});

  Future<Response> send<T>() async {
    if (!showLogs) {
      print("Welcome To Fore Astro Astrologer");
    } else if (method == "POST") {
      logger.w(
        "New $method Request Send : -> $url ",
        stackTrace: StackTrace.fromString("$method : $url"),
      );
    } else if (method == "GET") {
      logger.i(
        "New $method Request Send : -> $url ",
        stackTrace: StackTrace.fromString("$method : $url"),
      );
    } else if (method == "DELETE") {
      logger.w(
        "New $method Request Send : -> $url ",
        stackTrace: StackTrace.fromString("$method : $url"),
      );
    } else {
      logger.f(
        "New $method Request Send : -> $url ",
        stackTrace: StackTrace.fromString("$method : $url"),
      );
    }

    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      Response data = await dio.request<T>(
        url,
        data: body,
        options: options ??
            Options(method: method ?? ApiMethod.GET, headers: {
              'Authorization': 'Bearer ${sharedPreferences.getString("token")}'
            }),
      );
      if (showLogs) {
        logger.t(data.data,
            stackTrace: StackTrace.fromString("RESPONSE $method : $url"));
      }
      return data;
    } on DioException catch (e) {
      print(
          "======================= $method Dio Error ========================");
      logger.e(e.response?.data,
          error: e.error, stackTrace: StackTrace.fromString("$method : $url"));
      rethrow;
    } catch (e) {
      print(
          "======================= $method Catch Error ========================");
      logger.e(e, stackTrace: StackTrace.fromString("$method : $url"));
      rethrow;
    }
  }
}
