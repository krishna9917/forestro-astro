import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fore_astro_2/core/data/model/CommunicationModel.dart';
import 'package:fore_astro_2/core/data/repository/communicationRepo.dart';

class CommunicationProvider with ChangeNotifier {
  List<CommunicationModel>? _chats;
  List<CommunicationModel>? _calls;
  List<CommunicationModel>? _todayLogs;
  int _currentSlots = 0;
  bool _reloading = false;

  List<CommunicationModel>? get chats => _chats;
  List<CommunicationModel>? get calls => _calls;
  List<CommunicationModel>? get todayLogs => _todayLogs;

  bool get reloading => _reloading;
  int get currentSlots => _currentSlots;

  void nextSlots() {
    _currentSlots++;
    notifyListeners();
  }

  Future<Map<String, List<CommunicationModel>>> loadData() async {
    try {
      Response response = await CommunicationRepo.loadAllChatCallRequest();
      if (response.data['status'] == true) {
        List<CommunicationModel> chats = [];
        List<CommunicationModel> calls = [];
        List data = response.data['data'];
        int count = 0;

        for (var element in data) {
          // Only show pending requests in lists
          final status = element['status']?.toString().toLowerCase();
          if (status != null && status != 'pending') {
            continue;
          }

          if (element['type'].toString() == "chat") {
            chats.add(CommunicationModel.fromJson({...element, 'slot': count}));
          } else {
            calls.add(CommunicationModel.fromJson({...element, 'slot': count}));
          }
          count++;
        }

        return {
          "chats": chats,
          "calls": calls,
        };
      } else {
        return {
          "chats": [],
          "calls": [],
        };
      }
    } catch (e) {
      rethrow;
    }
  }

  Future loadInitData() async {
    try {
      Map<String, List<CommunicationModel>> response = await loadData();
      loadTodayLogs();
      _calls = response['calls'];
      _chats = response['chats'];
      _currentSlots = 0;

      // हर item के लिए timer start करो
      _chats?.forEach(startTimerForItem);
      _calls?.forEach(startTimerForItem);

      notifyListeners();
    } catch (e) {
      _calls = [];
      _chats = [];
      notifyListeners();
    }
  }

  Future reloadComunication({bool? isReload}) async {
    try {
      if (isReload == true) {
        _reloading = true;
        notifyListeners();
      }
      Map<String, List<CommunicationModel>> response = await loadData();
      loadTodayLogs();
      _calls = response['calls'];
      _chats = response['chats'];
      _currentSlots = 0;

      // हर item के लिए timer start करो
      _chats?.forEach(startTimerForItem);
      _calls?.forEach(startTimerForItem);

      _reloading = false;
      notifyListeners();
    } catch (e) {
      print(e);
      _reloading = false;
      notifyListeners();
      print("Error On Reload");
    }
  }

  removeFormChat(int id) {
    if (chats != null) {
      chats?.removeWhere((element) => element.id == id);
      _chats = List.generate(chats!.length, (index) => chats![index]);
      notifyListeners();
    }
    loadTodayLogs();
  }

  removeFormCall(int id) {
    if (calls != null) {
      calls?.removeWhere((element) => element.id == id);
      _calls = [...calls!];
      notifyListeners();
    }
    loadTodayLogs();
  }

  loadTodayLogs() async {
    try {
      Response logs = await CommunicationRepo.todayCommunicationLogs();
      if (logs.data['status'] == true) {
        _todayLogs = List.generate(
          logs.data['data'].length,
              (index) => CommunicationModel.fromJson(
            logs.data["data"][index],
          ),
        ).toList();
      } else {
        _todayLogs = [];
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  /// ✅ हर item के लिए timer start
  void startTimerForItem(CommunicationModel model) {
    if (model.time == null) return;

    try {
      final parts = model.time!.split(":"); // ["12", "00 AM"]
      int hour = int.parse(parts[0]);       // "12"
      final minuteParts = parts[1].trim().split(" "); // ["00", "AM"]
      int minute = int.parse(minuteParts[0]);
      String period = minuteParts[1].toUpperCase();   // "AM" or "PM"

      // 🔥 Proper AM/PM conversion
      if (period == "AM") {
        if (hour == 12) {
          hour = 0; // 12 AM -> 0 hour
        }
      } else if (period == "PM") {
        if (hour != 12) {
          hour += 12; // 1PM -> 13, ... 11PM -> 23
        }
      }

      DateTime scheduledTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        hour,
        minute,
      );

      model.timer?.cancel(); // पहले से चल रहा हो तो बंद करो

      model.timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final now = DateTime.now();
        model.elapsedSeconds = now.difference(scheduledTime).inSeconds;

        notifyListeners(); // UI update करो

        if (model.elapsedSeconds > 60 && model.status == "pending") {
          timer.cancel();
          updateStatusAndRemove(model);
        }
      });
    } catch (e) {
      debugPrint("Time parse error: ${model.time} -> $e");
    }
  }


  /// ✅ Status Update + Remove
  Future<void> updateStatusAndRemove(CommunicationModel model) async {
    try {
      await CommunicationRepo.acceptOrRejectRequest(
          communicationId: model.id.toString(),
          status: 'misscall'
      ); // तुम्हारी API
    } catch (e) {
      print("Error updating status: $e");
    }

    if (model.type == "chat") {
      removeFormChat(model.id!);
    } else {
      removeFormCall(model.id!);
    }
  }
}