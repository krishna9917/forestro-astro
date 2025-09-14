import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fore_astro_2/Components/ViewImage.dart';
import 'package:fore_astro_2/Components/profile/UserProfileInfoBox.dart';
import 'package:fore_astro_2/core/data/model/ClientModel.dart';
import 'package:fore_astro_2/core/data/model/PaymentHistoryModel.dart';
import 'package:fore_astro_2/core/data/repository/profileRepo.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:google_fonts/google_fonts.dart';

class UserProfileScreen extends StatefulWidget {
  final PaymentHistoryModel log;
  const UserProfileScreen({super.key, required this.log});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool loading = true;
  bool error = false;
  ClientProfileModel? clientProfileModel;

  @override
  void initState() {
    loadClientProfile();
    super.initState();
  }

  Future loadClientProfile() async {
    try {
      setState(() {
        error = false;
      });
      Response response =
          await ProfileRepo.getClient(widget.log.userId.toString());

      setState(() {
        loading = false;
        clientProfileModel = ClientProfileModel.fromJson(response.data['data']);
        error = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
        error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Builder(builder: (context) {
        if (loading) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColor.primary,
              strokeCap: StrokeCap.round,
            ),
          );
        }
        if (error) {
          return const Center(
            child: Text("Error To Load Log data! Try again later"),
          );
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: viewImage(
                      url: clientProfileModel?.profileImg.toString(),
                      boxDecoration: const BoxDecoration(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    clientProfileModel!.name.toString(),
                    style: GoogleFonts.inter(
                      color: Color(0xFF201F1F),
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    clientProfileModel!.email.toString(),
                    style: GoogleFonts.inter(
                      color: Color(0xFF515151),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    clientProfileModel!.phone.toString(),
                    style: GoogleFonts.inter(
                      color: const Color(0xFF515151),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 22),
                  UserInfoBox(
                      title: "Payment Details",
                      showEdit: false,
                      child: [
                        Row(
                          children: [
                            UserInfoBoxContent(
                              title: "Transaction ID",
                              content: widget.log.id.toString(),
                            ),
                            UserInfoBoxContent(
                              title: "Amount",
                              content: "₹ ${widget.log.totalAmount}",
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            UserInfoBoxContent(
                              title: "Status",
                              content: "${widget.log.status}".toUpperCase(),
                            ),
                            UserInfoBoxContent(
                              title: "Date",
                              content: widget.log.date.toString(),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            UserInfoBoxContent(
                              title: "Time",
                              content: widget.log.time.toString(),
                            ),
                          ],
                        )
                      ]),
                  const SizedBox(height: 30),
                  UserInfoBox(
                    showEdit: false,
                    title: "Call Details",
                    child: [
                      Row(
                        children: [
                          UserInfoBoxContent(
                            title: "Call ID",
                            content: widget.log.communicationId
                                .toString()
                                .toUpperCase(),
                          ),
                          UserInfoBoxContent(
                            title: "Duration",
                            content: "${widget.log.communicitionTime} Mins",
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
