import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fore_astro_2/core/data/model/kundali/dasha/anterdasha_model.dart';
import 'package:fore_astro_2/core/data/model/kundali/dasha/paryantardasha_model.dart';
import 'package:fore_astro_2/core/data/model/kundali/dasha/pranadasha_model.dart';
import 'package:fore_astro_2/core/data/model/kundali/dasha/shookshamadasha_model.dart';
import 'package:fore_astro_2/core/data/model/kundali/dasha/vimshotri_model.dart';

var dio = Dio();

formateTime(String birthTimeString) {
  final birthTimeParts = birthTimeString.split(':');
  final hours = birthTimeParts.length > 0 ? birthTimeParts[0] : '';
  final minutesPart = birthTimeParts.length > 1 ? birthTimeParts[1] : '';

  // Remove any 'AM' or 'PM' from the minutes part
  final minutes = minutesPart.replaceAll(RegExp(r'[^\d]'), '');

  // Pad hours and minutes if they are single digits
  final formattedHours = hours.padLeft(2, '0');
  final formattedMinutes = minutes.padLeft(2, '0');

  final formattedBirthTime = '$formattedHours:$formattedMinutes';
  return formattedBirthTime;
}

class VedicAstroAPIRepo {
  static getDetails(
    String path, {
    required String dob,
    required String tob,
    required double lat,
    required double lon,
    String lang = "en",
    String? response_type,
    String? planet,
  }) async {
    Map<String, dynamic> query = {
      'dob': dob,
      'tob': formateTime(tob),
      'lat': lat,
      'lon': lon,
      'tz': 5.5,
      'api_key': 'c9783a2d-98e9-5735-81e7-7c093ee21104',
      'lang': lang,
      'planet': planet ?? "Jupiter",
      "response_type": response_type,
    };

    try {
      var response = await dio.get(
        'https://api.vedicastroapi.com/v3-json/$path',
        queryParameters: query,
      );

      print(response.realUri);
      return response.data;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static getChartImage({
    required String dob,
    required String tob,
    required double lat,
    required double lon,
    String lang = "en",
  }) async {
    final Map<String, dynamic> queryParams = {
      'dob': dob,
      'tob': formateTime(tob),
      'lat': lat,
      'lon': lon,
      'tz': '5.5',
      'div': 'kp_chalit',
      'color': '#fe9612',
      'style': 'north',
      'font_size': '12',
      'font_style': 'roboto',
      'colorful_planets': '1',
      'size': '300',
      'stroke': '1',
      'format': 'base64',
      'api_key': 'c9783a2d-98e9-5735-81e7-7c093ee21104',
      'lang': 'en',
    };
    final url = 'https://api.vedicastroapi.com/v3-json/horoscope/chart-image';

    final response = await dio.get(url, queryParameters: queryParams);
    print(response.realUri);
    return response.data;
  }

  static getkundaliImage({
    required String dob,
    required String tob,
    required double lat,
    required double lon,
    String lang = "en",
  }) async {
    final Map<String, dynamic> queryParams = {
      'dob': dob,
      'tob': formateTime(tob),
      'lat': lat,
      'lon': lon,
      'tz': '5.5',
      'div': 'D1',
      'color': '#fe9612',
      'style': 'north',
      'font_size': '12',
      'font_style': 'roboto',
      'colorful_planets': '0',
      'size': '300',
      'stroke': '2',
      'format': 'base64',
      'api_key': 'c9783a2d-98e9-5735-81e7-7c093ee21104',
      'lang': 'en',
    };
    final url = 'https://api.vedicastroapi.com/v3-json/horoscope/chart-image';

    final response = await dio.get(url, queryParameters: queryParams);
    print(response.realUri);
    return response.data;
  }

  static getkundaliImages({
    required String dob,
    required String tob,
    required double lat,
    required double lon,
    String lang = "en",
  }) async {
    final Map<String, dynamic> queryParams = {
      'dob': dob,
      'tob': formateTime(tob),
      'lat': lat,
      'lon': lon,
      'tz': '5.5',
      'div': 'D1',
      'color': '#fe9612',
      'style': 'south',
      'font_size': '12',
      'font_style': 'roboto',
      'colorful_planets': '0',
      'size': '300',
      'stroke': '2',
      'format': 'base64',
      'api_key': 'c9783a2d-98e9-5735-81e7-7c093ee21104',
      'lang': 'en',
    };
    final url = 'https://api.vedicastroapi.com/v3-json/horoscope/chart-image';

    final response = await dio.get(url, queryParameters: queryParams);
    print(response.realUri);
    return response.data;
  }


  static divisionalChartData(
      {required String dob,
      required String tob,
      required double lat,
      required double lon,
      required String div}) async {
    try {
      final Map<String, dynamic> queryParams = {
        'dob': dob,
        'tob': formateTime(tob),
        'lat': lat,
        'lon': lon,
        'tz': '5.5',
        'div': div,
        'color': '%23ff3366',
        'style': 'north',
        'font_size': '12',
        'font_style': 'roboto',
        'colorful_planets': '1',
        'size': '300',
        'stroke': '2',
        'format': 'base64',
        'api_key': 'c9783a2d-98e9-5735-81e7-7c093ee21104',
        'lang': 'en',
      };
      print("quriparametterrr============$queryParams");
      final url = 'https://api.vedicastroapi.com/v3-json/horoscope/chart-image';

      final response = await dio.get(url, queryParameters: queryParams);
      print(response.realUri);
      return response.data;
    } catch (e) {
      print("fetch the error $e");
    }
  }

  static divisionalChartDatas(
      {required String dob,
      required String tob,
      required double lat,
      required double lon,
      required String div}) async {
    try {
      final Map<String, dynamic> queryParams = {
        'dob': dob,
        'tob': formateTime(tob),
        'lat': lat,
        'lon': lon,
        'tz': '5.5',
        'div': div,
        'color': '%23ff3366',
        'style': 'south',
        'font_size': '12',
        'font_style': 'roboto',
        'colorful_planets': '1',
        'size': '300',
        'stroke': '2',
        'format': 'base64',
        'api_key': 'c9783a2d-98e9-5735-81e7-7c093ee21104',
        'lang': 'en',
      };
      print("quriparametterrr============$queryParams");
      final url = 'https://api.vedicastroapi.com/v3-json/horoscope/chart-image';

      final response = await dio.get(url, queryParameters: queryParams);
      print(response.realUri);
      return response.data;
    } catch (e) {
      print("fetch the error $e");
    }
  }

  static vimsotridasa(
    String dob,
    String tob,
    double lat,
    double lon,
    String lang, {
    String? mahadashaName,
    String? ad,
    String? pd,
    String? sd,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'dob': dob,
        'tob': formateTime(tob),
        'lat': lat,
        'lon': lon,
        'tz': 5.5,
        'api_key': 'c9783a2d-98e9-5735-81e7-7c093ee21104',
        'lang': lang,
      };
      print("queryParams================$queryParams");
      if (mahadashaName != null) queryParams['md'] = mahadashaName;
      if (ad != null) queryParams['ad'] = ad;
      if (pd != null) queryParams['pd'] = pd;
      if (sd != null) queryParams['sd'] = sd;

      const url =
          'https://api.vedicastroapi.com/v3-json/dashas/specific-sub-dasha';

      final response = await dio.get(url, queryParameters: queryParams);
      print(response.realUri);
      print(response.data);
      return response.data;
    } catch (e) {
      print("Fetch error: $e");
    }
  }
}
