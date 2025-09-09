import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:fore_astro_2/core/data/model/UserModel.dart';
import 'package:fore_astro_2/core/data/model/kundali/Binnashtakvarga_Model.dart';
import 'package:fore_astro_2/core/data/model/kundali/Personal_Characteristics_Model.dart';
import 'package:fore_astro_2/core/data/model/kundali/assedent_model.dart';
import 'package:fore_astro_2/core/data/model/kundali/dasha/vimshotri_model.dart';
import 'package:fore_astro_2/core/data/model/kundali/kp_housemodel.dart';
import 'package:fore_astro_2/core/data/model/kundali/plannet_model.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:fore_astro_2/screens/pages/kundli/SearchLocation.dart';
import 'package:fore_astro_2/screens/pages/kundli/view/AscendantReport.dart';
import 'package:fore_astro_2/screens/pages/kundli/view/BasicInfo.dart';
import 'package:fore_astro_2/screens/pages/kundli/view/BinnashtakvargaInfo.dart';
import 'package:fore_astro_2/screens/pages/kundli/view/KpInfo.dart';
import 'package:fore_astro_2/screens/pages/kundli/view/PlanetInfo.dart';
import 'package:fore_astro_2/screens/pages/kundli/view/dasha.dart';
import 'package:fore_astro_2/screens/pages/kundli/view/dashacharts.dart';

class ViewKnuldliData extends StatelessWidget {
  final PlanetModel planetModel;
  final UserModel user;
  final String kundaliimge;
  final String kundaliimges;
  final String chart;
  final KpHouseModel kpHouseModel;
  final AsedentReportModel asedentReportModel;
  final Personal_Characteristics_Model personal_characteristics_model;
  final Binnashtakvarga_Model binnashtakvarga_model;
  final ExpectAddressLatLog expectAddressLatLog;
  final Vimsotridasa_Model mahadshamodel;
  final String dob;
  final String tob;
  final double lat;
  final double lng;
  final String lang;

  const ViewKnuldliData({
    super.key,
    required this.planetModel,
    required this.asedentReportModel,
    required this.personal_characteristics_model,
    required this.kpHouseModel,
    required this.binnashtakvarga_model,
    required this.chart,
    required this.user,
    required this.kundaliimge,
    required this.kundaliimges,
    required this.expectAddressLatLog,
    required this.mahadshamodel,
    required this.dob,
    required this.tob,
    required this.lat,
    required this.lng,
    required this.lang,
    // required vimsotridasa,
  });

  @override
  Widget build(BuildContext context) {
    print(user.phone);
    return DefaultTabController(
      length: 7,
      child: Scaffold(
          appBar: AppBar(
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: ButtonsTabBar(
                  // width: 180,
                  height: 40,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  contentCenter: true,
                  backgroundColor: AppColor.primary,
                  unselectedBackgroundColor: Colors.white,
                  unselectedLabelStyle:
                      const TextStyle(color: Color.fromARGB(255, 35, 35, 35)),
                  labelStyle: const TextStyle(color: Colors.white),
                  buttonMargin:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
                  tabs: const [
                    Tab(text: " Lagna "),
                    Tab(text: " Division charts "),
                    Tab(text: " Dasha "),
                    Tab(text: " KP "),
                    Tab(text: " Planet "),
                    Tab(text: " Ascendant Report "),
                    // Tab(text: " Kundali "),
                    Tab(text: " Binnashtakvarga "),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(children: [
            BasicInfo(
              planetModel: planetModel,
              user: user,
              chart: kundaliimge,
              charts: kundaliimges,
              asedentReportModel: asedentReportModel,
              expectAddressLatLog: expectAddressLatLog,
            ),
            DashaChartPage(
              dob: dob,
              tob: tob,
              lat: lat,
              lng: lng,
              lang: lang,
            ),
            DashaScreen(
              mahadshamodel: mahadshamodel,
              dob: dob,
              tob: tob,
              lat: lat,
              lng: lng,
              lang: lang,
            ),
            Kpinfo(chart: chart, kpHouseModel: kpHouseModel),
            PlanetInfo(planetModel: planetModel),
            AscendantReport(asedentReportModel: asedentReportModel),
            BinnashtakvargaInfo(binnashtakvarga_model: binnashtakvarga_model),
          ])),
    );
  }
}
