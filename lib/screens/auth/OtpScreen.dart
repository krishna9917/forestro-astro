import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fore_astro_2/constants/Assets.dart';
import 'package:fore_astro_2/core/data/repository/authRepo.dart';
import 'package:fore_astro_2/core/extensions/window.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:fore_astro_2/core/helper/helper.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:fore_astro_2/providers/UserProfileProvider.dart';
import 'package:fore_astro_2/screens/auth/CompletePofileScreen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:phone_input/phone_input_package.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  PhoneNumber phoneNumber;
  int astroId;

  OtpScreen({super.key, required this.astroId, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String otp = '';
  bool loading = false;
  bool resendLoading = false;
  bool disableResend = false;
  String _version = '';
  String _buildNumber = '';


Future<void> _loadPackageInfo() async {
PackageInfo packageInfo = await PackageInfo.fromPlatform();
setState(() {
_version = packageInfo.version;
_buildNumber = packageInfo.buildNumber;
});
print("build version number =======>>>>>>>>>>>>$_version $_buildNumber");
}
  // TODO: on submit otp  app
  Future<void> onSumbit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (otp.length != 4) {
      showToast("Enter Your Otp");
    } else {
      setState(() {
        loading = true;
      });
      try {
        try {
          Response response =
              await AuthRepo.astroVerifyOtp(widget.astroId.toString(), otp);
          if (response.data['status'] == true) {
            await prefs.setString("mobile", widget.phoneNumber.nsn);
            await prefs.setString("ccode", "${widget.phoneNumber.countryCode}");
            await prefs.setString(
                "id", response.data["data"]['astro_id'].toString());
            await prefs.setString("token", response.data['data']['token']);

            if (response.data["data"]['is_profile_created'] == true) {
              await context.read<UserProfileProvider>().getUserDataSplash();
            } else {
              navigateme.popUntil((route) => route.isFirst);
              navigateme.pushReplacement(routeMe(CompleteProfileScreen()));
            }
          } else {
            showToast("User Verification Failed");
          }
        } catch (e) {
          print(e);
          showToast("User Verification Failed");
        }
        setState(() {
          loading = false;
        });
      } catch (e) {
        setState(() {
          loading = false;
        });
        showToast("Invalid Otp");
      }
    }
  }

  // TODO: on submit otp  Resend  app
  Future<void> onResend() async {
    try {
      showToast("Resending Otp...");
      setState(() {
        resendLoading = true;
      });
      await AuthRepo.astroLogin(widget.phoneNumber.nsn,_version,_buildNumber);
      setState(() {
        disableResend = true;
        resendLoading = false;
      });
      showToast("Otp Resend Successfully");

      Timer(const Duration(seconds: 30), () {
        setState(() {
          disableResend = false;
        });
      });
    } catch (e) {
      showToast("Otp Resend failed! Please Try again");
      setState(() {
        resendLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.bgcolor,
      child: Stack(
        children: [
          Image.asset(
            AssetsPath.appBg,
            width: context.windowWidth,
            height: context.windowHeight,
            fit: BoxFit.cover,
          ),
          Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                children: [
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          navigateme.pop();
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 30,
                        ),
                      ),
                      SizedBox(
                        width: context.windowWidth - 80,
                        child: const ListTile(
                          title: Text(
                            "Verify Your OTP",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          subtitle: Text("Enter the OTP sent on your mobile"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: PinCodeTextField(
                      appContext: context,
                      length: 4,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(20.0),
                        fieldHeight: 60,
                        fieldWidth: context.windowWidth / 7,
                        activeFillColor: Colors.white,
                        selectedFillColor: Colors.white,
                        inactiveFillColor: Colors.white,
                        activeColor: AppColor.primary,
                        selectedColor: AppColor.primary,
                        inactiveColor: AppColor.primary,
                      ),
                      cursorColor: AppColor.primary,
                      animationDuration: const Duration(milliseconds: 300),
                      backgroundColor: Colors.transparent,
                      enableActiveFill: true,
                      keyboardType: TextInputType.number,
                      onCompleted: (String verificationCode) {
                        setState(() {
                          otp = verificationCode;
                        });
                        onSumbit();
                      },
                      onChanged: (value) {
                        setState(() {
                          otp = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        return true; 
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      width: context.windowWidth,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: loading ? null : onSumbit,
                        child: Builder(builder: (context) {
                          if (loading) {
                            return const SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                                strokeCap: StrokeCap.round,
                              ),
                            );
                          }
                          return const Text(
                            "Verify Your OTP",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Spacer(),
                  TextButton(
                    onPressed: resendLoading || disableResend ? null : onResend,
                    child: Text(
                      resendLoading ? "Resending Otp..." : "Resend OTP",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: resendLoading
                            ? AppColor.primary.withOpacity(0.7)
                            : disableResend
                                ? Colors.grey.withOpacity(0.6)
                                : AppColor.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
