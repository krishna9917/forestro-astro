import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fore_astro_2/core/data/model/BankModel.dart';
import 'package:fore_astro_2/core/data/repository/bankRepo.dart';

class BankAccountProvider with ChangeNotifier {
  List<BankModel>? _bankModel;
  BankModel? _primaryAccount;

  List<BankModel>? get bankModel => _bankModel;
  BankModel? get primaryAccount => _primaryAccount;

  Future loadBankdata() async {
    try {
      Response response = await BankRepo.loadBankAccounts();
      _bankModel = List.generate(response.data['data'].length,
          (index) => BankModel.fromJson(response.data['data'][index])).toList();

      _primaryAccount = null;
      for (var bank in _bankModel!) {
        if (bank.status == "1") {
          _primaryAccount = bank;
          break;
        }
      }

      notifyListeners();
    } catch (e) {
      print(e);
      _bankModel = [];
      notifyListeners();
    }
  }

  initLoadBanks() async {
    if (bankModel == null) {
      loadBankdata();
    }
  }
}
