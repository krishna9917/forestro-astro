import 'package:flutter/material.dart';
import 'package:fore_astro_2/Components/profile/UserProfileInfoBox.dart';
import 'package:fore_astro_2/core/data/model/kundali/assedent_model.dart';
import 'package:fore_astro_2/core/extensions/Text.dart';
import 'package:fore_astro_2/core/extensions/window.dart';

class AscendantReport extends StatelessWidget {
  final AsedentReportModel asedentReportModel;
  const AscendantReport({super.key, required this.asedentReportModel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Builder(builder: (context) {
          if (asedentReportModel.response == null ||
              asedentReportModel.response!.isEmpty) {
            return SizedBox();
          }
          Map data = asedentReportModel.response!.first.toJson();
          List dataKeys = data.keys.toList();
          return Column(
            children: [
              UserInfoBox(
                  title: "Ascendant Report",
                  showEdit: false,
                  child: List.generate(
                    dataKeys.length,
                    (index) {
                      return UserInfoBoxContent(
                          width: context.windowWidth,
                          title: dataKeys[index]
                              .toString()
                              .replaceAll("_", " ")
                              .capitalize(),
                          content: data[dataKeys[index]].toString());
                    },
                  )),
            ],
          );
        }),
      ),
    );
  }
}
