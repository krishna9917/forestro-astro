import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fore_astro_2/Components/ViewImage.dart';
import 'package:fore_astro_2/Components/profile/UserProfileInfoBox.dart';
import 'package:fore_astro_2/core/extensions/ListText.dart';
import 'package:fore_astro_2/core/extensions/window.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:fore_astro_2/providers/UserProfileProvider.dart';
import 'package:fore_astro_2/providers/bankAccoutProvider.dart';
import 'package:fore_astro_2/screens/main/ProfileUpdate/UpdateCertificationScreen.dart';
import 'package:fore_astro_2/screens/main/ProfileUpdate/UpdateImageScreen.dart';
import 'package:fore_astro_2/screens/main/ProfileUpdate/ViewBackAccountsScreen.dart';
import 'package:fore_astro_2/screens/main/ProfileUpdate/personalDetailsUpdateScreen.dart';
import 'package:fore_astro_2/screens/main/ProfileUpdate/profileUpdateScreen.dart';
import 'package:fore_astro_2/screens/main/ProfileUpdate/updateProfessionalDetails.dart';
import 'package:provider/provider.dart';

class ProfiletabView extends StatelessWidget {
  const ProfiletabView({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColor.primary,
      onRefresh: () async {
        context.read<BankAccountProvider>().loadBankdata();
        await context.read<UserProfileProvider>().reloadProfile();
      },
      child: SingleChildScrollView(
        child: Consumer<UserProfileProvider>(builder: (context, state, child) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                const SizedBox(width: 15),
                Center(
                    child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        navigateme.push(routeMe(const UpdateImageScreen()));
                      },
                      child: viewImage(
                          url: state.userProfileModel?.profileImg,
                          boxDecoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100))),
                    ),
                  ],
                )),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 40,
                    ),
                    Text(
                      state.userProfileModel?.name ?? "User Name",
                      style: const TextStyle(
                        color: Color(0xFF201F1F),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          navigateme.push(
                              routeMe(const ProfileUpdateScreen(), isauth: true));
                        },
                        icon: Icon(
                          Icons.edit_outlined,
                          size: 18,
                          color: AppColor.primary,
                        )),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 20, top: 5, left: 15, right: 15),
                  child: Text(
                    state.userProfileModel?.description ?? "Update Your Bio",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF515151),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                // Personal Details Box
                UserInfoBox(
                  title: "Personal Details",
                  onPressed: () {
                    navigateme.push(
                        routeMe(PersonalDetailsUpdateScreen(), isauth: true));
                  },
                  child: [
                    Row(
                      children: [
                        UserInfoBoxContent(
                          title: "Date of Birth",
                          content: state.userProfileModel?.dateOfBirth ??
                              "Not Found",
                        ),
                        UserInfoBoxContent(
                          title: "Birthplace",
                          content:
                              state.userProfileModel?.birthPlace ?? "Not Found",
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        UserInfoBoxContent(
                          title: "Current Location",
                          content: state.userProfileModel?.city ?? "Not Found",
                        ),
                        UserInfoBoxContent(
                          title: "ID (Aadhar)",
                          content:
                              state.userProfileModel?.adharId ?? "Not Found",
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        UserInfoBoxContent(
                          title: "Gender",
                          content:
                              state.userProfileModel?.gender ?? "Not Found",
                        ),
                        UserInfoBoxContent(
                          title: "Pan Card",
                          content:
                              state.userProfileModel?.panNumber ?? "Not Found",
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 20),
                // Professional Details box
                UserInfoBox(
                  title: "Professional Details",
                  onPressed: () {
                    navigateme.push(
                        routeMe(const UpdateProfessionalDetails(), isauth: true));
                  },
                  child: [
                    Row(
                      children: [
                        UserInfoBoxContent(
                          title: "Experience",
                          content: state.userProfileModel?.experience != null
                              ? "${state.userProfileModel!.experience!} years"
                              : "Not Found",
                        ),
                        UserInfoBoxContent(
                          title: "Language",
                          content: state.userProfileModel!.languaage!
                              .displayLanguages(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        UserInfoBoxContent(
                          title: "Education",
                          content:
                              state.userProfileModel?.education ?? "Not Found",
                        ),
                        UserInfoBoxContent(
                            title: "Call Charges",
                            content: state
                                        .userProfileModel?.callChargesPerMin !=
                                    null
                                ? "₹  ${state.userProfileModel!.callChargesPerMin!} Per Min"
                                : "Not Found"),
                      ],
                    ),
                    Row(
                      children: [
                        UserInfoBoxContent(
                            title: "Chat Charges",
                            content: state
                                        .userProfileModel?.chatChargesPerMin !=
                                    null
                                ? "₹  ${state.userProfileModel!.chatChargesPerMin!} Per Min"
                                : "Not Found"),
                        UserInfoBoxContent(
                            title: "Video Charges",
                            content: state
                                        .userProfileModel?.chatChargesPerMin !=
                                    null
                                ? "₹  ${state.userProfileModel!.videoChargesPerMin!} Per Min"
                                : "Not Found"),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 20),

                UserInfoBox(
                    title: "Certification",
                    onPressed: () {
                      navigateme.push(routeMe(const UpdateCertificationScreen()));
                    },
                    child: List.generate(
                      state.userProfileModel?.certifications?.length ?? 0,
                      (index) => UserCertificationBox(
                        certifications:
                            state.userProfileModel!.certifications![index],
                      ),
                    )),
                const SizedBox(height: 20),

                Consumer<BankAccountProvider>(builder: (context, bank, child) {
                  return UserInfoBox(
                      title: "Bank Details",
                      onPressed: () {
                        navigateme.push(
                            routeMe(const ViewBankAccountScreen(), isauth: true));
                      },
                      child: [
                        UserInfoBoxContent(
                          title: bank.primaryAccount?.name ?? "Bank Name",
                          content: bank.primaryAccount?.accountNumber ??
                              "No Primary Bank Account Selected",
                          width: context.windowWidth,
                        )
                      ]);
                }),
                const SizedBox(height: 80),
              ],
            ),
          );
        }),
      ),
    );
  }
}
