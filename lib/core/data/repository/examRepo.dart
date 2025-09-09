import 'package:dio/dio.dart';
import 'package:fore_astro_2/core/data/api/ApiRequest.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExamRepo {
  // https://foreastro.bonwic.cloud/api/onboarding-questions
  static Future<Response> loadExam<T>() async {
    try {
      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/onboarding-questions",
        method: ApiMethod.GET,
      );
      return await apiRequest.send<T>();
    } catch (e) {
      rethrow;
    }
  }

// https://foreastro.bonwic.cloud/api/onboarding-answer
  static Future<Response> submitAnswer<T>(
      {required String question, required String answer}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");
      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/onboarding-answer",
        method: ApiMethod.POST,
        body: packFormData(
          {
            "astro_id": id,
            "question": question,
            "answer": answer,
          },
        ),
      );
      return await apiRequest.send<T>();
    } catch (e) {
      rethrow;
    }
  }
}
