import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fore_astro_2/core/data/model/LiveHistryModel.dart';
import 'package:fore_astro_2/core/data/repository/liveRepo.dart';
import 'package:fore_astro_2/core/helper/helper.dart';

class LiveDataProvider with ChangeNotifier {
  List<AstroLiveHistoryModel> _historyData = [];
  List<AstroLiveHistoryModel> get historyData => _historyData;
  bool _loading = true;
  bool get loading => _loading;

  Future liveHistory() async {
    try {
      Response data = await LiveRepo.liveHistory();
      List logs = data.data['data'];
      _loading = false;
      _historyData = List.generate(
        logs.length,
        (index) => AstroLiveHistoryModel.fromJson(logs[index]),
      );

      notifyListeners();
    } catch (e) {
      print(e);
      _loading = false;
      notifyListeners();
    }
  }
}
