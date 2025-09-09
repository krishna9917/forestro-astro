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
        print("_chats: $data");
        int count = 0;
        data.forEach((element) {
          print(element['type']);
          if (element['type'].toString() == "chat") {
            chats.add(CommunicationModel.fromJson({...element, 'slot': count}));
          } else {
            calls.add(CommunicationModel.fromJson({...element, 'slot': count}));
          }
          count++;
        });
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
      print("_chats: $_chats");
      _currentSlots = 0;
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
      print("_chats: $_chats");
      _currentSlots = 0;
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
}
