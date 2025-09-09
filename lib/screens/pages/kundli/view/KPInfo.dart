import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fore_astro_2/Components/profile/UserProfileInfoBox.dart';
import 'package:fore_astro_2/core/data/model/kundali/kp_housemodel.dart';
import 'package:fore_astro_2/core/extensions/Text.dart';
import 'package:fore_astro_2/core/extensions/window.dart';

class Kpinfo extends StatelessWidget {
  final String chart;
  final KpHouseModel kpHouseModel;
  const Kpinfo({super.key, required this.chart, required this.kpHouseModel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            SizedBox(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        width: 1.5,
                        color: const Color.fromARGB(255, 234, 234, 234)),
                    borderRadius: BorderRadius.circular(20)),
                child: SvgPicture.string(
                  chart,
                  width: context.windowWidth,
                ),
              ),
            ),
            SizedBox(height: 30),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: kpHouseModel.response!.length,
              itemBuilder: (context, index) {
                Map data = kpHouseModel.response![index].toJson();
                List datakeys = data.keys.toList();

                return Column(
                  children: [
                    UserInfoBox(
                        title: "",
                        showTitle: false,
                        showEdit: false,
                        child: List.generate(
                          datakeys.length,
                          (i) {
                            if (datakeys[i] == "planets") {
                              return SizedBox();
                            }
                            return UserInfoBoxContent(
                              title: datakeys[i]
                                  .toString()
                                  .replaceAll("_", " ")
                                  .capitalize(),
                              content: data[datakeys[i]].toString(),
                              width: context.windowWidth,
                            );
                          },
                        )),
                    Builder(
                      builder: (context) {
                        if (data['planets'] != null &&
                            data["planets"].length != 0) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 15),
                            child: UserInfoBox(
                                title: "Planets",
                                showEdit: false,
                                child: [
                                  Row(
                                    children: [
                                      UserInfoBoxContent(
                                          title: "Name",
                                          content: data["planets"][0]
                                              ['full_name']),
                                      UserInfoBoxContent(
                                          title: "Nakshatra",
                                          content: data["planets"][0]
                                              ['nakshatra'])
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      UserInfoBoxContent(
                                          title: "Nakshatra No",
                                          content: data["planets"][0]
                                                  ['nakshatra_no']
                                              .toString()),
                                      UserInfoBoxContent(
                                          title: "Nakshatra Pada",
                                          content: data["planets"][0]
                                                  ['nakshatra_pada']
                                              .toString())
                                    ],
                                  )
                                ]),
                          );
                        } else {
                          return SizedBox(height: 15);
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
