import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fore_astro_2/Components/CallList.dart';
import 'package:fore_astro_2/core/data/model/LogModel.dart';
import 'package:fore_astro_2/core/data/repository/dataLogsRepo.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';

class ChatHistory extends StatefulWidget {
  const ChatHistory({super.key});

  @override
  State<ChatHistory> createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  List<LogModel>? logs;

  @override
  void initState() {
    chatLogs();
    super.initState();
  }

  Future chatLogs() async {
    try {
      Response response = await DataLogsRepo.chatLogs();
      setState(() {
        logs = List.generate(response.data['data'].length,
                (index) => LogModel.fromJson(response.data['data'][index]))
            .toList();
      });
    } catch (e) {
      setState(() {
        logs = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat History".toUpperCase()),
      ),
      body: RefreshIndicator(
        color: AppColor.primary,
        onRefresh: () async {
          chatLogs();
        },
        child: Builder(
          builder: (context) {
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
                  return ChatListCard(
                    log: logs![index],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
