import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_astro_2/Components/Inputs/CompleteProfileInputBox.dart';
import 'package:fore_astro_2/constants/ListofData.dart';
import 'package:fore_astro_2/core/data/model/UserProfileModel.dart';
import 'package:fore_astro_2/core/data/repository/profileRepo.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:fore_astro_2/core/helper/helper.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:fore_astro_2/providers/UserProfileProvider.dart';
import 'package:provider/provider.dart';

class UpdateProfessionalDetails extends StatefulWidget {
  const UpdateProfessionalDetails({super.key});

  @override
  State<UpdateProfessionalDetails> createState() =>
      _UpdateProfessionalDetailsState();
}

class _UpdateProfessionalDetailsState extends State<UpdateProfessionalDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool loading = false;

  late String experience;
  late List<String> userLanguages;
  TextEditingController educationController = TextEditingController();
  TextEditingController callPmController = TextEditingController();
  TextEditingController videoCallPmController = TextEditingController();
  TextEditingController chatPmController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  @override
  void initState() {
    UserProfileModel? userProfileModel =
        context.read<UserProfileProvider>().userProfileModel;

    experience = userProfileModel?.experience ?? "";
    userLanguages = userProfileModel?.languaage ?? [];
    educationController.text = userProfileModel?.education ?? "";
    callPmController.text = userProfileModel?.callChargesPerMin ?? "";
    videoCallPmController.text = userProfileModel?.videoChargesPerMin ?? "";
    chatPmController.text = userProfileModel?.callChargesPerMin ?? "";
    startTimeController.text = userProfileModel?.startTimeSlot ?? "";
    endTimeController.text = userProfileModel?.endTimeSlot ?? "";
    bioController.text = userProfileModel?.description ?? "";

    super.initState();
  }

  Future saveFrom() async {
    try {
      if (experience.isEmpty) {
        showToast("Select Your Experience");
        return false;
      }
      if (userLanguages.isEmpty) {
        showToast("Select Your Languages");
        return false;
      }

      setState(() {
        loading = true;
      });

      Response response = await ProfileRepo.updateAstroProfessionalDetails(
        experience: experience,
        call_charges_per_min: callPmController.text,
        chat_charges_per_min: chatPmController.text,
        video_charges_per_min: videoCallPmController.text,
        education: educationController.text,
        start_time_slot: startTimeController.text,
        languaage: userLanguages,
        end_time_slot: endTimeController.text,
        description: bioController.text,
      );
      if (response.data['status'] == true) {
        context.read<UserProfileProvider>().reloadProfile();
        showToast(response.data['message'] ?? "Profile Update Successfully");
        navigateme.pop();
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
        title: Text("Professional Details".toUpperCase()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CompleteProfileSelectBox(
                  title: "Experience",
                  onChanged: (e) {
                    setState(() {
                      experience = e!;
                    });
                  },
                  list: [
                    experience,
                    ...List.generate(50, (index) => "${index + 1} Years")
                  ],
                ),
                SizedBox(height: 15),
                MultiSelectBox(
                  title: "Language",
                  list: languages,
                  initialItems: userLanguages,
                  onListChanged: (e) {
                    setState(() {
                      userLanguages = e;
                    });
                  },
                ),
                SizedBox(height: 15),
                CompleteProfileInputBox(
                  title: "Education",
                  textEditingController: educationController,
                  validator: (e) {
                    if (e == null || e.isEmpty) {
                      return "Enter Your Education";
                    }
                    return null;
                  },
                ),
                // SizedBox(height: 15),
                // CompleteProfileInputBox(
                //   title: "Call Charges Per Minute",
                //   keyboardType: TextInputType.number,
                //   textEditingController: callPmController,
                //   prefixIcon: Icon(
                //     FontAwesomeIcons.inr,
                //     size: 15,
                //   ),
                //   validator: (e) {
                //     if (e == null || e.isEmpty) {
                //       return "Enter Call Charges Per Minute";
                //     }
                //     return null;
                //   },
                // ),
                // SizedBox(height: 15),
                // CompleteProfileInputBox(
                //   title: "Video Charges Per Minute",
                //   keyboardType: TextInputType.number,
                //   textEditingController: videoCallPmController,
                //   validator: (e) {
                //     if (e == null || e.isEmpty) {
                //       return "Enter Video Charges Per Minute";
                //     }
                //     return null;
                //   },
                //   prefixIcon: Icon(
                //     FontAwesomeIcons.inr,
                //     size: 15,
                //   ),
                // ),
                // SizedBox(height: 15),
                // CompleteProfileInputBox(
                //   title: "Chat Charges Per Minute",
                //   keyboardType: TextInputType.number,
                //   textEditingController: chatPmController,
                //   validator: (e) {
                //     if (e == null || e.isEmpty) {
                //       return "Enter Chat Charges Per Minute";
                //     }
                //     return null;
                //   },
                //   prefixIcon: Icon(
                //     FontAwesomeIcons.inr,
                //     size: 15,
                //   ),
                // ),
                SizedBox(height: 15),
                CompleteProfileInputBox(
                  title: "Start Time Slot",
                  readOnly: true,
                  textEditingController: startTimeController,
                  validator: (e) {
                    if (e == null || e.isEmpty) {
                      return "Enter Start Time Slot";
                    }
                    return null;
                  },
                  onTap: () {
                    getTimePicker(context, onUpdate: (e) {
                      setState(() {
                        final hour = e.hourOfPeriod == 0
                            ? 12
                            : e.hourOfPeriod; // convert hour '0' to '12'
                        final minute = e.minute.toString().padLeft(
                            2, '0'); // ensure minute is always two digits
                        final period = e.period == DayPeriod.am ? 'AM' : 'PM';
                        startTimeController.text = "$hour:$minute $period";
                      });
                    });
                  },
                  suffixIcon: Icon(
                    FontAwesomeIcons.clock,
                    size: 15,
                  ),
                ),
                SizedBox(height: 15),
                CompleteProfileInputBox(
                  title: "End Time Slot",
                  readOnly: true,
                  textEditingController: endTimeController,
                  validator: (e) {
                    if (e == null || e.isEmpty) {
                      return "Enter End Time Slot";
                    }
                    return null;
                  },
                  onTap: () {
                    getTimePicker(context, onUpdate: (e) {
                      setState(() {
                        final hour = e.hourOfPeriod == 0 ? 12 : e.hourOfPeriod;
                        final minute = e.minute.toString().padLeft(2, '0');
                        final period = e.period == DayPeriod.am ? 'AM' : 'PM';
                        endTimeController.text = "$hour:$minute $period";
                      });
                    });
                  },
                  suffixIcon: Icon(
                    FontAwesomeIcons.clock,
                    size: 15,
                  ),
                ),
                SizedBox(height: 15),
                CompleteProfileInputBox(
                  title: "Profile Bio",
                  maxLines: 5,
                  textEditingController: bioController,
                  validator: (e) {
                    if (e == null || e.isEmpty) {
                      return "Enter Your Bio";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
              ],
            ),
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
                        FocusScope.of(context).requestFocus(new FocusNode());
                        if (_formKey.currentState?.validate() == true) {
                          saveFrom();
                        }
                      },
                child: Text(loading ? "Saving.." : "Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
