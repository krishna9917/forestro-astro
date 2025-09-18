import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fore_astro_2/Components/PhoneInputBox.dart';
import 'package:fore_astro_2/constants/Assets.dart';
import 'package:fore_astro_2/core/data/repository/authRepo.dart';
import 'package:fore_astro_2/core/extensions/window.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:fore_astro_2/core/helper/helper.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:fore_astro_2/package/phoneinput/src/number_parser/models/phone_number.dart';
import 'package:fore_astro_2/screens/auth/OtpScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  PhoneNumber? phoneNumber;
  bool loading = false;
  String _version = '';
  String _buildNumber = '';
  @override
  void initState() {
    _loadPackageInfo();
    super.initState();
  }

  Future<void> _loadPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
    });
    print("build version number =======>>>>>>>>>>>>$_version $_buildNumber");
  }

// TODO: Handeal on Form Submit
  Future<void> onClick() async {
  await  _loadPackageInfo();
    if (phoneNumber == null) {
      showToast("Enter Valid Mobile Number");
    } else if (!phoneNumber!.isValid()) {
      showToast("Enter Valid Mobile Number");
    } else {
      setState(() {
        loading = true;
      });

      try {
        Response response =
            await AuthRepo.astroLogin(phoneNumber!.nsn, _version, _buildNumber);
        print("build version number $_version $_buildNumber");
        if (response.data['status'] == true) {
          navigateme.push(
            routeMe(
              OtpScreen(
                  astroId: response.data['astro_id'],
                  phoneNumber: phoneNumber!),
            ),
          );
          setState(() {
            loading = false;
          });
        } else {
          setState(() {
            loading = false;
          });
          showToast("Something went wrong");
        }
      } catch (e) {
        setState(() {
          loading = false;
        });

        print(e);
        showToast("Something went wrong");
      }
    }
  }

// TODO: On Google Login
  Future<void> onGoogle() async {}

// TODO: On Facebook Login
  Future<void> onFacebook() async {}

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
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 85),
                    Image.asset(
                      AssetsPath.appLogo,
                      width: 120,
                    ),
                    const SizedBox(height: 20),
                     Text(
                      "Welcome to Fore Astro Astrologer",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(
                                  "Phone No",
                                  style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              InputPhoneNo(
                                autofocus: true,
                                onChanged: (data) {
                                  setState(() {
                                    phoneNumber = data;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: context.windowWidth,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: loading ? null : onClick,
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
                                return  Text(
                                  "Continue Verification",
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 50),
                          Center(
                            child: Text.rich(
                              textAlign: TextAlign.center,
                              TextSpan(
                                text: 'By Proceeding, I agree to  ',
                                children: <InlineSpan>[
                                  TextSpan(
                                      text: 'Terms and Conditions ',
                                      style: GoogleFonts.inter(
                                        color: AppColor.primary,
                                        decoration: TextDecoration.underline,
                                        decorationColor: AppColor.primary,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          launchUrl(
                                              Uri.parse(
                                                "https://foreastro.com/terms-of-use",
                                              ),
                                              mode: LaunchMode
                                                  .externalApplication);
                                        }),
                                  TextSpan(
                                    text: ' & ',
                                  ),
                                  TextSpan(
                                      text: ' Privacy Policy',
                                      style: GoogleFonts.inter(
                                        color: AppColor.primary,
                                        decoration: TextDecoration.underline,
                                        decorationColor: AppColor.primary,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          launchUrl(
                                              Uri.parse(
                                                "https://foreastro.com/privacy-policy",
                                              ),
                                              mode: LaunchMode
                                                  .externalApplication);
                                        })
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          // OrTextLine()
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 30),
                    //   child: Column(
                    //     children: [
                    //       LoginSocailBtn(
                    //         image: AssetsPath.googleIcon,
                    //         title: "Continue With Google",
                    //         onTap: loading ? null : onGoogle,
                    //       ),
                    //       const SizedBox(height: 20),
                    //       LoginSocailBtn(
                    //         image: AssetsPath.facebookIcon,
                    //         title: "Continue With Facebook",
                    //         onTap: loading ? null : onFacebook,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrTextLine extends StatelessWidget {
  const OrTextLine({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: context.windowWidth / 2 - 155,
          height: 0.7,
          color: Colors.black,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text("Or Sign up with"),
        ),
        Container(
          width: context.windowWidth / 2 - 155,
          height: 0.7,
          color: Colors.black,
        ),
      ],
    );
  }
}

class LoginSocailBtn extends StatelessWidget {
  final String image;
  final String title;
  void Function()? onTap;
  LoginSocailBtn({
    required this.image,
    required this.title,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 248, 248, 248),
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              image,
              width: 30,
              height: 30,
              fit: BoxFit.cover,
            ),
            Text(
              title,
              style:  GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 61, 61, 61),
              ),
            ),
            const SizedBox(width: 30),
          ],
        ),
      ),
    );
  }
}
