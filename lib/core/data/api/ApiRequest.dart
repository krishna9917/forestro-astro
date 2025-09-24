import 'package:dio/dio.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Removed auto-logout navigation

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
  final bool ignoreUnauthorized;

  ApiRequest(this.url,
      {this.method,
      this.body,
      this.options,
      this.showLogs = kDebugMode,
      this.ignoreUnauthorized = false});

  dynamic _freshBody() {
    if (body is FormData) {
      final FormData original = body as FormData;
      final FormData copy = FormData();
      copy.fields.addAll(List<MapEntry<String, String>>.from(original.fields));
      copy.files.addAll(List<MapEntry<String, MultipartFile>>.from(original.files));
      return copy;
    }
    return body;
  }

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
      // Avoid network hits completely when offline
      final List<ConnectivityResult> connectivity = await Connectivity().checkConnectivity();
      if (connectivity.contains(ConnectivityResult.none)) {
        throw const SocketException('No Internet connection');
      }

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      Response data = await dio.request<T>(
        url,
        data: _freshBody(),
        options: options ??
            Options(method: method ?? ApiMethod.GET, headers: {
              'Authorization': 'Bearer ${sharedPreferences.getString("token")}'
            }),
      );
      if (showLogs) {
        logger.t(data.data,
            stackTrace: StackTrace.fromString("RESPONSE $method : $url"));
      }
      // Removed global auto-logout on 401 payloads
      return data;
    } on DioException catch (e) {
      print(
          "======================= $method Dio Error ========================");
      logger.e(e.response?.data,
          error: e.error, stackTrace: StackTrace.fromString("$method : $url"));
      // Retry once with alternate domain if DNS lookup failed
      final bool isHostLookupError =
          e.error is SocketException ||
              (e.message?.toLowerCase().contains('failed host lookup') ?? false);
      if (isHostLookupError && url.contains("foreastro.technovaedge.in")) {
        final String alternateUrl =
            url.replaceFirst("foreastro.technovaedge.in", "foreastro.com");
        try {
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          Response data = await dio.request<T>(
            alternateUrl,
            data: _freshBody(),
            options: options ??
                Options(method: method ?? ApiMethod.GET, headers: {
                  'Authorization':
                      'Bearer ${sharedPreferences.getString("token")}'
                }),
          );
          if (showLogs) {
            logger.t(data.data,
                stackTrace:
                    StackTrace.fromString("RESPONSE $method : $alternateUrl"));
          }
          // Update global apiUrl so subsequent requests use the working domain
          apiUrl = apiUrl.replaceFirst(
              "https://foreastro.technovaedge.in", "https://foreastro.com");
          // Removed auto-logout logic in retry branch as well
          return data;
        } on DioException catch (retryError) {
          logger.e(retryError.response?.data,
              error: retryError.error,
              stackTrace: StackTrace.fromString("RETRY $method : $alternateUrl"));
          // Surface a network-friendly error to allow UI to route to NoInternet screen
          throw SocketException('Failed host lookup after retry');
        }
      }
      // For network errors, allow callers to detect and show NoInternet
      rethrow;
    } catch (e) {
      print(
          "======================= $method Catch Error ========================");
      logger.e(e, stackTrace: StackTrace.fromString("$method : $url"));
      rethrow;
    }
  }
}
