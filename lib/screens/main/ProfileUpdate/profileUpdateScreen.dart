import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fore_astro_2/Components/Inputs/CompleteProfileInputBox.dart';
import 'package:fore_astro_2/constants/ListofData.dart';
import 'package:fore_astro_2/core/data/model/UserProfileModel.dart';
import 'package:fore_astro_2/core/data/repository/profileRepo.dart';
import 'package:fore_astro_2/core/extensions/validate.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:fore_astro_2/core/helper/helper.dart';
import 'package:fore_astro_2/providers/UserProfileProvider.dart';
import 'package:provider/provider.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({super.key});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  late String specialization;
  bool loading = false;
  @override
  void initState() {
    UserProfileModel? userProfileProvider =
        context.read<UserProfileProvider>().userProfileModel;
    _nameController.text = userProfileProvider?.name ?? "";
    _emailController.text = userProfileProvider?.email ?? "";
    _bioController.text = userProfileProvider?.description ?? "";
    specialization = userProfileProvider?.specialization ?? "";
    super.initState();
  }

  Future saveFrom() async {
    try {
      if (specialization.isEmpty) {
        showToast("Select Your Specialization");
        return false;
      }
      setState(() {
        loading = true;
      });

      Response response = await ProfileRepo.astroUpdateProfileInfo(
        name: _nameController.text,
        email: _emailController.text,
        specialization: specialization,
        description: _bioController.text,
      );

      if (response.data['status'] == true) {
        showToast(response.data['message'] ?? "Profile Update Successfully");
        navigateme.pop();
        context.read<UserProfileProvider>().reloadProfile();
      } else {
        showToast("Profile Update Error. Please Try later");
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
        title: Text("Profile Details".toUpperCase()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CompleteProfileInputBox(
                title: "Name",
                textEditingController: _nameController,
                validator: (e) {
                  if (e == null || e.isEmpty) {
                    return "Enter Your Name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              CompleteProfileInputBox(
                title: "Email",
                textEditingController: _emailController,
                validator: (e) {
                  if (e == null || e.isEmpty) {
                    return "Enter Your Email ID";
                  }
                  if (!e.isValidEmail()) {
                    return "Invalid Email ID";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              CompleteProfileSelectBox(
                title: "Specialization",
                list: [specialization, ...astrologerSpecializations],
                onChanged: (e) {
                  setState(() {
                    specialization = e!;
                  });
                },
              ),
              SizedBox(height: 15),
              CompleteProfileInputBox(
                title: "Profile Bio",
                maxLines: 5,
                textEditingController: _bioController,
                validator: (e) {
                  if (e == null || e.isEmpty) {
                    return "Enter Your Bio";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        height: 60,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
                onPressed: loading ? null : () {},
                child: Text(
                  "Cancel",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            SizedBox(width: 20),
            SizedBox(
                width: 120,
                child: ElevatedButton(
                    onPressed: loading
                        ? null
                        : () {
                            if (_formKey.currentState?.validate() == true) {
                              saveFrom();
                            }
                          },
                    child: Text(loading ? "Saving.." : "Save"))),
          ],
        ),
      ),
    );
  }
}
