import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fore_astro_2/core/data/model/CouponModel.dart';
import 'package:fore_astro_2/core/data/repository/couponRepo.dart';

class CouponProvider extends ChangeNotifier {
  List<CouponModel>? _chatCoupons;
  List<CouponModel>? _audioCallCoupons;
  List<CouponModel>? _videoCallCoupons;
  bool _loading = true;

// Getter for _chatCoupons
  List<CouponModel>? get chatCoupons => _chatCoupons;

  // Getter for _audioCallCoupons
  List<CouponModel>? get audioCallCoupons => _audioCallCoupons;

  // Getter for _videoCallCoupons
  List<CouponModel>? get videoCallCoupons => _videoCallCoupons;

  // Getter for _loading
  bool get loading => _loading;

  Future loadCoupons() async {
    try {
      Response response = await CouponRepo.getCoupons<Map>();
      Map data = response.data['data'];
      List chat = data['chat_coupon'];
      List audio = data['audio_coupon'];
      List video = data['video_coupon'];

      _loading = false;
      _chatCoupons = List.generate(
        chat.length,
        (index) => CouponModel.fromJson(chat[index]),
      );
      _audioCallCoupons = List.generate(
        audio.length,
        (index) => CouponModel.fromJson(audio[index]),
      );
      _videoCallCoupons = List.generate(
        video.length,
        (index) => CouponModel.fromJson(video[index]),
      );
      notifyListeners();
    } catch (e) {
      _loading = false;
      _chatCoupons = [];
      _audioCallCoupons = [];
      _videoCallCoupons = [];
      notifyListeners();
    }
  }
}
