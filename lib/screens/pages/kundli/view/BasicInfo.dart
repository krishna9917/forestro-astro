import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fore_astro_2/Components/profile/UserProfileInfoBox.dart';
import 'package:fore_astro_2/core/data/model/UserModel.dart';
import 'package:fore_astro_2/core/data/model/kundali/assedent_model.dart';
import 'package:fore_astro_2/core/data/model/kundali/plannet_model.dart';
import 'package:fore_astro_2/core/extensions/Text.dart';
import 'package:fore_astro_2/core/extensions/window.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:fore_astro_2/screens/pages/kundli/SearchLocation.dart';
import 'package:google_fonts/google_fonts.dart';

class BasicInfo extends StatelessWidget {
  final PlanetModel planetModel;
  final UserModel user;
  final String chart;
  final String charts;
  final ExpectAddressLatLog expectAddressLatLog;
  final AsedentReportModel asedentReportModel;
  const BasicInfo(
      {super.key,
      required this.planetModel,
      required this.user,
      required this.chart,
      required this.charts,
      required this.asedentReportModel,
      required this.expectAddressLatLog});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        width: 1.5,
                        color: const Color.fromARGB(255, 234, 234, 234)),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // const Text("North"),
                    SvgPicture.string(
                      chart,
                      width: context.windowWidth,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        width: 1.5,
                        color: const Color.fromARGB(255, 234, 234, 234)),
                    borderRadius: BorderRadius.circular(20)),
                child: SvgPicture.string(
                  charts,
                  width: context.windowWidth,
                ),
              ),
            ),
            const SizedBox(height: 30),
            UserInfoBox(title: "Basic Details", showEdit: false, child: [
              UserInfoBoxContent(
                title: "Name",
                content: user.name.toString(),
                width: context.windowWidth,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserInfoBoxContent(
                    title: "Date Of Birth",
                    content: user.dateOfBirth.toString().replaceAll("-", "/"),
                  ),
                  UserInfoBoxContent(
                    title: "Date Of Birth",
                    content: user.birthTime.toString().replaceAll("-", "/"),
                  ),
                ],
              ),
              UserInfoBoxContent(
                title: "Location",
                content: expectAddressLatLog.address,
                width: context.windowWidth,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserInfoBoxContent(
                    title: "Latitude",
                    content: expectAddressLatLog.let.toString(),
                  ),
                  UserInfoBoxContent(
                    title: "Longitude",
                    content: expectAddressLatLog.lng.toString(),
                  ),
                ],
              ),
              UserInfoBoxContent(
                title: "Time Zone",
                content: "GMT+5.5",
                width: context.windowWidth,
              ),
            ]),
            const SizedBox(height: 20),
            Builder(builder: (context) {
              if (asedentReportModel.response == null) {
                return const SizedBox();
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: asedentReportModel.response!.length,
                itemBuilder: (context, index) {
                  Map data = asedentReportModel.response![index].toJson();
                  List<String> keys = asedentReportModel.response![index]
                      .toJson()
                      .keys
                      .toList();

                  return UserInfoBox(
                      title: "",
                      showTitle: false,
                      showEdit: false,
                      child: List.generate(
                        keys.length,
                        (index) => UserInfoBoxContent(
                          title: keys[index]
                              .toString()
                              .replaceAll("_", " ")
                              .capitalize(),
                          content: data[keys[index]].toString(),
                          textStyle: GoogleFonts.inter(
                              fontSize: 12, fontWeight: FontWeight.w500),
                          width: context.windowWidth,
                        ),
                      ));
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
