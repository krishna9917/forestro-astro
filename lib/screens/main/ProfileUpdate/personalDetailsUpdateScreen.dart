import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fore_astro_2/Components/Inputs/CompleteProfileInputBox.dart';
import 'package:fore_astro_2/constants/ListofData.dart';
import 'package:fore_astro_2/core/data/model/UserProfileModel.dart';
import 'package:fore_astro_2/core/data/repository/profileRepo.dart';
import 'package:fore_astro_2/core/extensions/Text.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:fore_astro_2/core/helper/helper.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:fore_astro_2/providers/UserProfileProvider.dart';
import 'package:fore_astro_2/screens/pages/kundli/SearchLocation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PersonalDetailsUpdateScreen extends StatefulWidget {
  @override
  State<PersonalDetailsUpdateScreen> createState() =>
      _PersonalDetailsUpdateScreenState();
}

class _PersonalDetailsUpdateScreenState
    extends State<PersonalDetailsUpdateScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _dobController = TextEditingController();
  TextEditingController _borthPlaceController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController city=TextEditingController();
  TextEditingController state=TextEditingController();
  TextEditingController pin=TextEditingController();
  TextEditingController _adharIdController = TextEditingController();
  TextEditingController _panIdController = TextEditingController();

  late String gender;


  bool loading = false;

  @override
  void initState() {
    UserProfileModel? userProfileProvider =
        context.read<UserProfileProvider>().userProfileModel;

    _dobController.text = userProfileProvider?.dateOfBirth ?? "";
    _borthPlaceController.text = userProfileProvider?.birthPlace ?? "";
    _addressController.text = userProfileProvider?.address ?? "";
    state.text= userProfileProvider?.state ?? "";
    city.text= userProfileProvider?.city ?? "";
    pin.text= userProfileProvider?.pinCode ?? "";

    _adharIdController.text = userProfileProvider?.adharId ?? "";
    _panIdController.text = userProfileProvider?.panNumber ?? "";
    gender = userProfileProvider?.gender ?? "";
    super.initState();
  }

  Future saveFrom() async {
    try {
      if (gender.isEmpty) {
        showToast("Select Your gender");
        return false;
      }
      if (state.text.isEmpty || city.text.isEmpty || pin.text.isEmpty) {
        showToast("Select Your State, City and Pin Code");
        return false;
      }
      if(pin.text.length!=6){
        showToast("Enter Valid Pin Code");
        return false;
      }

      setState(() {
        loading = true;
      });

      Response response = await ProfileRepo.updateAstroPersonalDetails(
        dob: _dobController.text,
        borthPlace: _borthPlaceController.text.capitalize(),
        city: city.text,
        adharId: _adharIdController.text,
        panNumber: _panIdController.text,
        gender: gender,
        address: _addressController.text,
        state: state.text,
        pinCode: pin.text,
      );
      if (response.data['status'] == true) {
        showToast(response.data['message'] ?? "Profile Update Successfully");
        await context.read<UserProfileProvider>().reloadProfile();
        navigateme.pop();
      }
      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      showToast("Profile Update Error. Please Try later");
    }
  }

  // Future<void> getStateCity() async {
  //   try {
  //     final dio = Dio();
  //     final url = "https://api.postalpincode.in/pincode/${pin.text}";
  //
  //
  //     final response = await dio.get(url);
  //
  //
  //     if (response.statusCode == 200) {
  //       final res = response.data is String
  //           ? jsonDecode(response.data)
  //           : response.data;
  //
  //       if (res is List && res.isNotEmpty) {
  //         final postOffices = res[0]["PostOffice"] as List?;
  //
  //         if (postOffices != null && postOffices.isNotEmpty) {
  //           final first = postOffices.first as Map<String, dynamic>;
  //
  //           final stateValue = first["State"] ?? "";
  //           final blockValue = first["Block"] ?? "";
  //
  //
  //
  //           setState(() {
  //             state.text = stateValue;
  //             city.text = blockValue;
  //
  //           });
  //         } else {
  //           setState(() {
  //             state.text = "";
  //             city.text = "";
  //
  //           });
  //
  //           showToast("No post office details found for this pin code.");
  //         }
  //       } else {
  //
  //         showToast("Invalid response format from API.");
  //       }
  //     } else {
  //       print("❌ Server error: ${response.statusCode}");
  //       setState(() {
  //         state.text = "";
  //         city.text = "";
  //
  //       });
  //       showToast("Server error: ${response.statusCode}");
  //     }
  //   } on DioException catch (e) {
  //     print("❌ Dio error: ${e.message}");
  //     showToast("This pin code is not valid. Please try a different pin code.");
  //   } catch (e) {
  //
  //     print("❌ Unexpected error: $e");
  //     showToast("An unexpected error occurred. Please try again later.");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Personal Details".toUpperCase()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(children: [
              CompleteProfileInputBox(
                title: "Date of Birth",
                textEditingController: _dobController,
                readOnly: true,
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2015, 12),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: Colors.white, // header background color
                            background: Colors.white,
                            onBackground: AppColor.primary,
                            onPrimary: AppColor.primary, // header text color
                            onSurface: Colors.black, // body text color
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  AppColor.primary, // button text color
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        _dobController.text =
                            value.toIso8601String().formatDate();
                      });
                    }
                  });
                },
                validator: (e) {
                  if (e == null || e.isEmpty) {
                    return "Enter Your Date of Birth";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              CompleteProfileSelectBox(
                title: "Gender",
                list: [gender, "Male", "Female", "Others"],
                onChanged: (e) {
                  setState(() {
                    gender = e!;
                  });
                },
              ),
              const SizedBox(height: 15),
              CompleteProfileInputBox(
                title: "Birthplace",
                textEditingController: _borthPlaceController,
                validator: (e) {
                  if (e == null || e.isEmpty) {
                    return "Enter Your Birthplace";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              CompleteProfileInputBox(
                title: "Address Line 1",
                textEditingController: _addressController,
                validator: (e) {
                  if (e == null || e.isEmpty) {
                    return "Enter Your Address Line 1";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              CompleteProfileInputBox(
                hintText: "Enter PinCode",
                // onChanged: ((value) {
                //   if (value.isNotEmpty && value.length > 5) {
                //     getStateCity();
                //   }
                // }),
                maxLength: 6,
                inputFormatter: [
                  LengthLimitingTextInputFormatter(6),
                  FilteringTextInputFormatter.digitsOnly
                ],
                textEditingController: pin,
                keyboardType: TextInputType.number,
                title: "PinCode",
                validator: (e) {
                  if (e == null || e.isEmpty) {
                    return "Please Enter Your Area Pin Code";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              CompleteProfileInputBox(
                title: "Enter Place",
                textEditingController: TextEditingController(text: "${city.text}, ${state.text}"),
                readOnly: true,
                hintText: "Search with city name",
                prefixIcon: const Icon(Icons.location_on_rounded),
                onTap: () {
                  navigateme.push(routeMe(GoogleMapSearchPlacesApi(
                    onSelect: (e) {
                      setState(() {
                        if(e.city?.isEmpty??false || (e.state?.isEmpty??false)){
                          showToast("Please search with city name");
                        }else{
                          city.text = e.city??"";
                          state.text = e.state??"";
                          // locationData = e;
                        }
                      });
                    },
                  )));
                },
              ),

              // CompleteProfileInputBox(
              //   hintText: "State",
              //   enable:  false,
              //   textEditingController: state,
              //   title: "State",
              //
              // ),
              // const SizedBox(height: 15),
              // CompleteProfileInputBox(
              //   hintText: "City",
              //
              //   enable: false,
              //   textEditingController: city,
              //   title: "City",
              //   validator: (e) {
              //     if (e == null || e.isEmpty) {
              //       return "Please Enter Your City";
              //     }
              //     return null;
              //   },
              // ),
              const SizedBox(height: 15),
              CompleteProfileInputBox(
                title: "AADHAAR ID",
                textEditingController: _adharIdController,
                keyboardType: TextInputType.number,
                validator: (e) {
                  if (e == null || e.isEmpty) {
                    return "Enter Your Aadhaar No";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              CompleteProfileInputBox(
                title: "PAN No.",
                textEditingController: _panIdController,
                validator: (e) {
                  if (e == null || e.isEmpty) {
                    return "Enter Your Pan No.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
            ]),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        height: 60,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
                onPressed: loading
                    ? null
                    : () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        navigateme.pop();
                      },
                child:  Text(
                  "Cancel",
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                )),
            const SizedBox(width: 20),
            SizedBox(
                width: 120,
                child: ElevatedButton(
                    onPressed: loading
                        ? null
                        : () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            if (_formKey.currentState?.validate() == true) {
                              saveFrom();
                            }
                            ;
                          },
                    child: Text(loading ? "Saving.." : "Save"))),
          ],
        ),
      ),
    );
  }
}
