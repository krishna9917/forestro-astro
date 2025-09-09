import 'package:dio/dio.dart';
import 'package:fore_astro_2/core/data/api/ApiRequest.dart';
import 'package:fore_astro_2/core/data/repository/profileRepo.dart';
import 'package:fore_astro_2/core/pushNotification/Notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LiveRepo {
  // "https://foreastro.bonwic.cloud/api//astrologer-live-histories?astro_id=51
  static Future<Response> liveHistory<T>() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");

      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/astrologer-live-histories?astro_id=$id",
        method: ApiMethod.GET,
      );
      return await apiRequest.send<T>();
    } catch (e) {
      rethrow;
    }
  }

  // send Push notification
  static Future sendPushNotification(
      {required String title,
      required String body,
      required Map<String, String> content}) async {
    try {
      Response response = await ProfileRepo.getFollowers();
      List data = response.data['data'];
      List ofIds = List.generate(data.length, (index) {
        String id = data[index]['notification_token'];
        return id;
      }).toList();

      List<Future> requests = List.generate(
          ofIds.length,
          (index) async => await NotificationService.sendPushMessage(
              ofIds[index],
              title: title,
              body: body,
              data: content));

      await Future.wait(requests);
    } catch (e) {
      print(e);
    }
  }
}
