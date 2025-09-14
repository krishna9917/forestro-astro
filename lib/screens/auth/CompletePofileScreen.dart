import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fore_astro_2/Components/Inputs/CertificationPicker.dart';
import 'package:fore_astro_2/Components/Inputs/CompleteProfileInputBox.dart';
import 'package:fore_astro_2/Components/NewImagePicker.dart';
import 'package:fore_astro_2/constants/Assets.dart';
import 'package:fore_astro_2/constants/ListofData.dart';
import 'package:fore_astro_2/core/data/api/ApiRequest.dart';
import 'package:fore_astro_2/core/data/repository/authRepo.dart';
import 'package:fore_astro_2/core/extensions/Text.dart';
import 'package:fore_astro_2/core/extensions/validate.dart';
import 'package:fore_astro_2/core/extensions/window.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:fore_astro_2/core/helper/helper.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:fore_astro_2/screens/auth/Exam/AstroExamScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});
  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;
  List<File> profileImg = [];
  String? gender;
  String? specialization;
  String? state;
  List<PlatformFile> certifications = [];
  List<String> langue = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _aadheerController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  bool validateAll() {
    if (profileImg == null) {
      showToast("Select Your Profile Image");
      return false;
    }

    if (gender == null) {
      showToast("Select Your Gender");
      return false;
    }

    if (specialization == null) {
      showToast("Select Your Specialization");
      return false;
    }

    if (state == null) {
      showToast("Select Your State");
      return false;
    }

    // This Is Optional
    // if (certifications.isEmpty) {
    //   showToast("Select Your Certifications Files");
    //   return false;
    // }

    if (langue.isEmpty) {
      showToast("Select Your Languages");
      return false;
    }

    return true;
  }

  putAllData() async {
    if (validateAll()) {
      setState(() {
        loading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");

      try {
        List<List<MultipartFile>> files = [];

        for (var certification in certifications) {
          MultipartFile newfile = await addFormFile(
            certification.path!,
            filename: certification.name,
          );
          files.add([newfile]);
        }
        List<List<MultipartFile>> imageFiles = [];

        for (var img in profileImg) {
          MultipartFile newfile = await addFormFile(
            img.path,
            filename: img.path.getFileName(),
          );
          imageFiles.add([newfile]);
        }

        FormData formData = packFormData({
          'name': _nameController.text,
          'email': _emailController.text,
          'mobile_number': _mobileController.text,
          'gender': gender,
          'adhar_id': _aadheerController.text,
          'pan_number': _panController.text.toUpperCase(),
          'specialization': specialization,
          'language': jsonEncode(langue),
          'address': _addressController.text,
          'city': _cityController.text,
          'state': state,
          'pin_code': _pincodeController.text.toUpperCase(),
          'astro_id': id,
          'certifications': files,
          'profile_images': imageFiles,
        });

        Response response = await AuthRepo.createProfile(formData);
        setState(() {
          loading = false;
        });
        if (response.data['status'] == true) {
          // Navigate Home Page
          navigateme.popUntil((route) => route.isFirst);
          // navigateme.pushReplacement(routeMe(const WettingScreen()));
          navigateme.pushReplacement(routeMe(const AstroExamScreen()));
        } else {
          showToast(toastError);
        }
      } on DioException catch (e) {
        setState(() {
          loading = false;
        });
        if (e.response?.data['status'] == false) {
          Map error = e.response?.data['data'];
          showToast(error[error.keys.first][0] ?? toastError);
          return false;
        }

        showToast(toastError);
      } catch (e) {
        setState(() {
          loading = false;
        });
        showToast(toastError);
      }
    }
  }

  @override
  void initState() {
    setInitData();
    super.initState();
  }

  setInitData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _mobileController.text =
        "+${prefs.getString("ccode")} ${prefs.getString("mobile")}";
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
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    actions: const [
                      // TextButton(
                      //     onPressed: () async {
                      //       await context.read<SocketProvider>().logoutUse();
                      //     },
                      //     child: const Text("Logout ")),
                      SizedBox(width: 10),
                    ],
                  ),
                  const SizedBox(height: 15),
                   Center(
                    child: Text(
                      'Complete your Profile',
                      style: GoogleFonts.inter(
                        color: Color(0xFF201F1F),
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: NewImagePicker(
                      onSelect: (e) {
                        setState(() {
                          profileImg = e!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CompleteProfileInputBox(
                              title: "Full Name",
                              textEditingController: _nameController,
                              validator: (e) {
                                if (e == null || e.isEmpty) {
                                  return "Please Enter Your Name";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            CompleteProfileSelectBox(
                              title: "Gender",
                              list: const ["", "Male", "Female", "Others"],
                              onChanged: (e) {
                                setState(() {
                                  gender = e;
                                });
                              },
                            ),
                            const SizedBox(height: 15),
                            CompleteProfileInputBox(
                              textEditingController: _emailController,
                              title: "Email",
                              validator: (e) {
                                if (e == null || e.isEmpty) {
                                  return "Please Enter Your Email ID";
                                }
                                if (!e.isValidEmail()) {
                                  return "Invalid Email ID";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            CompleteProfileInputBox(
                              textEditingController: _mobileController,
                              title: "Phone No",
                              readOnly: true,
                              validator: (e) {
                                if (e == null || e.isEmpty) {
                                  return "Please Enter Phone No.";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            CertificationPicker(
                              onSelect: (e) {
                                certifications = e;
                              },
                            ),
                            const SizedBox(height: 15),
                            CompleteProfileInputBox(
                              textEditingController: _aadheerController,
                              title: "Aadhaar ID",
                              validator: (e) {
                                if (e == null || e.isEmpty) {
                                  return "Please Enter Your Aadhaar ID No.";
                                }
                                if (e.length != 12) {
                                  return "Invalid Aadhaar No";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            CompleteProfileInputBox(
                              textEditingController: _panController,
                              title: "PAN No.",
                              validator: (e) {
                                if (e == null || e.isEmpty) {
                                  return "Please Enter Your Pan NO.";
                                }
                                if (e.length != 10) {
                                  return "Invalid PAN No.";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            CompleteProfileSelectBox(
                              title: "Specialization",
                              list: ["", ...astrologerSpecializations],
                              onChanged: (e) {
                                setState(() {
                                  specialization = e;
                                });
                              },
                            ),
                            const SizedBox(height: 15),
                            MultiSelectBox(
                              title: "Language",
                              initialItems: langue,
                              hintText: "Select Languages",
                              list: languages,
                              onListChanged: (e) {
                                setState(() {
                                  langue = e;
                                });
                              },
                            ),
                            const SizedBox(height: 22),
                             Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Address',
                                style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            CompleteProfileInputBox(
                              textEditingController: _addressController,
                              title: "Address",
                              validator: (e) {
                                if (e == null || e.isEmpty) {
                                  return "Please Enter Your Address";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            CompleteProfileSelectBox(
                              title: "State",
                              list: ['', ...states],
                              onChanged: (e) {
                                state = e;
                              },
                            ),
                            const SizedBox(height: 15),
                            CompleteProfileInputBox(
                              textEditingController: _cityController,
                              title: "City",
                              validator: (e) {
                                if (e == null || e.isEmpty) {
                                  return "Please Enter Your City";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            CompleteProfileInputBox(
                              textEditingController: _pincodeController,
                              keyboardType: TextInputType.number,
                              title: "PinCode",
                              validator: (e) {
                                if (e == null || e.isEmpty) {
                                  return "Please Enter Your Area Pin Code";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 35),
                            SizedBox(
                              width: context.windowWidth,
                              height: 60,
                              child: ElevatedButton(
                                onPressed: loading
                                    ? null
                                    : () {
                                        if (_formKey.currentState?.validate() ==
                                            true) {
                                          putAllData();
                                        }
                                        // navigateme.push(routeMe(WettingScreen()));
                                      },
                                child: Builder(builder: (context) {
                                  if (loading) {
                                    return const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    );
                                  }
                                  return  Text(
                                    "Submit",
                                    style: GoogleFonts.inter(fontSize: 20),
                                  );
                                }),
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        )),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
