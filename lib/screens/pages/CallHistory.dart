import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fore_astro_2/Components/CallList.dart';
import 'package:fore_astro_2/core/data/model/LogModel.dart';
import 'package:fore_astro_2/core/data/repository/dataLogsRepo.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:fore_astro_2/screens/pages/kundli/KundliForm.dart';

class CallHistory extends StatefulWidget {
  const CallHistory({super.key});

  @override
  State<CallHistory> createState() => _CallHistoryState();
}

class _CallHistoryState extends State<CallHistory> {
  List<LogModel>? logs;

  @override
  void initState() {
    loadLogs();
    super.initState();
  }

  Future loadLogs() async {
    try {
      Response response = await DataLogsRepo.callLogs();
      print(response.data);
      setState(() {
        logs = List.generate(response.data['data'].length,
                (index) => LogModel.fromJson(response.data['data'][index]))
            .toList();
      });
    } catch (e) {
      print(e);
      setState(() {
        logs = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Call History".toUpperCase()),
      ),
      body: RefreshIndicator(
        color: AppColor.primary,
        onRefresh: () async {
          loadLogs();
        },
        child: Builder(builder: (context) {
          if (logs == null) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColor.primary,
                strokeCap: StrokeCap.round,
              ),
            );
          }
          if (logs!.isEmpty) {
            return Center(
              child: Text("No History Found"),
            );
          }
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListView.builder(
                itemCount: logs!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      navigateme.push(routeMe(KundliForm(
                        id: logs![index].userId!,
                        name: logs![index].name,
                      )));
                    },
                    child: ChatListCard(
                      log: logs![index],
                    ),
                  );
                },
              ));
        }),
      ),
    );
  }
}
