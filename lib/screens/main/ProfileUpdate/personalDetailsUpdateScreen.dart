import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fore_astro_2/Components/Inputs/CompleteProfileInputBox.dart';
import 'package:fore_astro_2/constants/ListofData.dart';
import 'package:fore_astro_2/core/data/model/UserProfileModel.dart';
import 'package:fore_astro_2/core/data/repository/profileRepo.dart';
import 'package:fore_astro_2/core/extensions/Text.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:fore_astro_2/core/helper/helper.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:fore_astro_2/providers/UserProfileProvider.dart';
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
  TextEditingController _cityController = TextEditingController();
  TextEditingController _adharIdController = TextEditingController();
  TextEditingController _panIdController = TextEditingController();

  late String gender;
  late String state;

  bool loading = false;

  @override
  void initState() {
    UserProfileModel? userProfileProvider =
        context.read<UserProfileProvider>().userProfileModel;

    _dobController.text = userProfileProvider?.dateOfBirth ?? "";
    _borthPlaceController.text = userProfileProvider?.birthPlace ?? "";
    _addressController.text = userProfileProvider?.address ?? "";
    state = userProfileProvider?.state ?? "";
    _cityController.text = userProfileProvider?.city ?? "";
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
      if (state.isEmpty) {
        showToast("Select Your gender");
        return false;
      }

      setState(() {
        loading = true;
      });

      Response response = await ProfileRepo.updateAstroPersonalDetails(
        dob: _dobController.text,
        borthPlace: _borthPlaceController.text.capitalize(),
        city: _cityController.text.capitalize(),
        adharId: _adharIdController.text,
        panNumber: _panIdController.text,
        gender: gender,
        address: _addressController.text,
        state: state,
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
              CompleteProfileSelectBox(
                title: "State",
                list: [state, ...states],
                onChanged: (e) {
                  setState(() {
                    state = e!;
                  });
                },
              ),
              const SizedBox(height: 15),
              CompleteProfileInputBox(
                title: "City",
                textEditingController: _cityController,
                validator: (e) {
                  if (e == null || e.isEmpty) {
                    return "Enter Your City";
                  }
                  return null;
                },
              ),
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
                child: const Text(
                  "Cancel",
                  style: TextStyle(fontWeight: FontWeight.bold),
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
