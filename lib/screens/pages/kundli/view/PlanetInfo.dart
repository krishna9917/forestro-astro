import 'package:flutter/material.dart';
import 'package:fore_astro_2/Components/profile/UserProfileInfoBox.dart';
import 'package:fore_astro_2/core/data/model/kundali/plannet_model.dart';

class PlanetInfo extends StatelessWidget {
  final PlanetModel planetModel;
  const PlanetInfo({super.key, required this.planetModel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 15),
        child: Builder(builder: (context) {
          var data = planetModel.response!.toJson();

          List planetData = data.keys.toList();
          List count = planetData.where((element) {
            return int.tryParse(element) != null;
          }).toList();

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserInfoBox(
                title: "Planet Basic Info",
                showEdit: false,
                child: [
                  Row(
                    children: [
                      UserInfoBoxContent(
                        title: "Rasi",
                        content: planetModel.response!.rasi,
                      ),
                      UserInfoBoxContent(
                        title: "Nakshatra",
                        content: planetModel.response!.nakshatra,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      UserInfoBoxContent(
                        title: "Birth Dasa",
                        content: planetModel.response!.birthDasa,
                      ),
                      UserInfoBoxContent(
                        title: "Current Dasa",
                        content: planetModel.response!.currentDasa,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      UserInfoBoxContent(
                        title: "Lucky Colors",
                        content: planetModel.response!.luckyColors!.join(","),
                      ),
                      UserInfoBoxContent(
                        title: "Lucky Gem",
                        content: planetModel.response!.luckyGem!.join(","),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              ListView.builder(
                itemCount: count.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      UserInfoBox(
                        title: "${data["$index"]['full_name']}",
                        showEdit: false,
                        child: [
                          Row(
                            children: [
                              UserInfoBoxContent(
                                title: "Zodiac",
                                content: "${data["$index"]['zodiac']}",
                              ),
                              UserInfoBoxContent(
                                title: "Zodiac Lord",
                                content: "${data["$index"]['zodiac_lord']}",
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              UserInfoBoxContent(
                                title: "Rasi no",
                                content: "${data["$index"]['rasi_no']}",
                              ),
                              UserInfoBoxContent(
                                title: "House",
                                content: "${data["$index"]['house']}",
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              UserInfoBoxContent(
                                title: "Nakshatra",
                                content: "${data["$index"]['nakshatra']}",
                              ),
                              UserInfoBoxContent(
                                title: "Nakshatra Lord",
                                content: "${data["$index"]['nakshatra_lord']}",
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              UserInfoBoxContent(
                                title: "Nakshatra",
                                content: "${data["$index"]['nakshatra']}",
                              ),
                              UserInfoBoxContent(
                                title: "Nakshatra Lord",
                                content: "${data["$index"]['nakshatra_lord']}",
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              UserInfoBoxContent(
                                title: "Nakshatra Pada",
                                content: "${data["$index"]['nakshatra_pada']}",
                              ),
                              UserInfoBoxContent(
                                title: "Nakshatra No",
                                content: "${data["$index"]['nakshatra_no']}",
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ],
          );
        }),
      ),
    );
  }
}
