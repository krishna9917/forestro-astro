import 'package:dio/dio.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fore_astro_2/core/data/api/ApiRequest.dart';
import 'package:fore_astro_2/core/data/model/UserProfileModel.dart';
import 'package:fore_astro_2/core/data/repository/authRepo.dart';
import 'package:fore_astro_2/core/data/repository/profileRepo.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:fore_astro_2/core/helper/helper.dart';
import 'package:fore_astro_2/screens/auth/CompletePofileScreen.dart';
import 'package:fore_astro_2/screens/auth/Exam/AstroExamScreen.dart';
import 'package:fore_astro_2/screens/auth/LoginScreen.dart';
import 'package:fore_astro_2/screens/auth/WattingScreen.dart';
import 'package:fore_astro_2/screens/main/HomeTabScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fore_astro_2/screens/common/NoInternetScreen.dart';

class UserProfileProvider with ChangeNotifier {
  UserProfileModel? _userProfileModel;
  UserProfileModel? get userProfileModel => _userProfileModel;

  Future getUserDataSplash() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
    try {
      String? id = prefs.getString("id");

      String? mobile = prefs.getString("mobile");
      if (id == null && mobile == null) {
        navigateme.pushReplacement(routeMe(const LoginScreen()));
        return false;
      }

      Response responseAuth = await AuthRepo.astroProfile();

      if (responseAuth.data['status'] == true) {
        if (responseAuth.data['data']['is_profile_created'] == false) {
          navigateme.pushReplacement(routeMe(const CompleteProfileScreen()));
          return false;
        }

        if (responseAuth.data['status'] == true) {
          _userProfileModel =
              UserProfileModel.fromJson(responseAuth.data['data']);
          notifyListeners();
          //navigate To Home Page

          if (userProfileModel?.isOnboardingCompleted == false) {
            navigateme.popUntil((route) => route.isFirst);
            navigateme
                .pushReplacement(routeMe(const AstroExamScreen(), isauth: true));
          } else {
            if (_userProfileModel?.profileStatus == "pending") {
              navigateme.popUntil((route) => route.isFirst);
              navigateme
                  .pushReplacement(routeMe(WettingScreen(status: "pending",), isauth: true));
            }  else if (_userProfileModel?.profileStatus == "rejected"){
              navigateme.popUntil((route) => route.isFirst);
              navigateme
                  .pushReplacement(routeMe(WettingScreen(status:"rejected",remark: _userProfileModel?.remark), isauth: true));
            }

            else {
              navigateme.popUntil((route) => route.isFirst);
              navigateme
                  .pushReplacement(routeMe(HomeTabScreen(), isauth: true));
            }
          }
        } else {
          navigateme.pushReplacement(routeMe(const LoginScreen()));
        }
      } else {
        navigateme.pushReplacement(routeMe(const LoginScreen()));
      }
    } on DioException catch (e) {
      print(e);
      showToast(toastError);
    } on SocketException catch (_) {
      // route to NoInternet screen
      try {
        navigateme.push(routeMe(const NoInternetScreen()));
      } catch (_) {}
    } catch (e) {
      print(e);

      showToast(toastError);
    }
  }

  Future reloadProfile() async {
    try {
      Response response = await ProfileRepo.astroProfile();
      if (response.data['status'] == true) {
        _userProfileModel = UserProfileModel.fromJson(response.data['data']);
        notifyListeners();
      }
    } catch (e) {
      print("Error To Reload Profile");
    }
  }

  Future toggleOnline(bool status) async {
    showToast("Switching to ${status ? "online" : "offline"} mode");
    try {
      Response response = await ProfileRepo.setAstroOnlineOROffline(status);
      if (response.data['status'] == true) {
        await reloadProfile();
        showToast("You Are ${status ? "Online" : "Offline"} Now");
      }
    } catch (e) {
      showToast("Failed To Update Online Status");
    }
  }
}
