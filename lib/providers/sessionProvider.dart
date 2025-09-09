import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fore_astro_2/Components/RequestBox.dart';

class SessionProvider with ChangeNotifier {
  DateTime? _startTime;
  DateTime? _endTime;
  int _sec = 0;
  RequestType _sessionType = RequestType.None;
  Timer? _timer;

  DateTime? get startTime => _startTime;
  DateTime? get endTime => _endTime;
  int get sec => _sec;
  RequestType get sessionType => _sessionType;

  void newSession(RequestType type) {
    clearSession();
    _sessionType = type;
    _startTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _sec = sec + 1;
      notifyListeners();
    });
  }

  void closeSession() {
    _endTime = DateTime.now();
    _timer?.cancel();
    notifyListeners();
  }

  void clearSession() async {
    closeSession();
    _sec = 0;
    _endTime = null;
    _startTime = null;
    _timer = null;
    _sessionType = RequestType.None;
    notifyListeners();
  }
}
