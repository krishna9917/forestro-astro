import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fore_astro_2/core/data/model/CommunicationModel.dart';
import 'package:fore_astro_2/core/data/repository/communicationRepo.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:fore_astro_2/providers/sockets/socketProvider.dart';
import 'package:fore_astro_2/screens/Comunication/viewAll/ViewAllRequestScreen.dart';

class SearchRequestScreen extends StatefulWidget {
  const SearchRequestScreen({super.key});

  @override
  State<SearchRequestScreen> createState() => _SearchRequestScreenState();
}

class _SearchRequestScreenState extends State<SearchRequestScreen> {
  bool loading = false;
  TextEditingController controller = TextEditingController();
  List<CommunicationModel>? chatRequests;
  List<CommunicationModel>? callRequests;

  searchRequests() async {
    if (controller.text.isNotEmpty) {
      FocusManager.instance.primaryFocus?.unfocus();

      try {
        setState(() {
          loading = true;
        });
        Response response =
            await CommunicationRepo.searchRequests(controller.text);
        setState(() {
          chatRequests = List.generate(
                  response.data['chat'].length,
                  (index) =>
                      CommunicationModel.fromJson(response.data['call'][index]))
              .toList();
          callRequests = List.generate(
                  response.data['call'].length,
                  (index) =>
                      CommunicationModel.fromJson(response.data['call'][index]))
              .toList();
          loading = false;
        });
      } catch (e) {
        setState(() {
          chatRequests = [];
          callRequests = [];
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            onEditingComplete: () => searchRequests(),
            autofocus: true,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Search Request",
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              focusedBorder: InputBorder.none,
            ),
          ),
          bottom: TabBar(
            indicatorColor: AppColor.primary,
            labelColor: AppColor.primary,
            overlayColor:
                MaterialStatePropertyAll(AppColor.primary.withOpacity(0.1)),
            tabs: [
              const Tab(text: "Chat Requests"),
              const Tab(text: "Call Requests"),
            ],
          ),
        ),
        body: Builder(builder: (context) {
          if (loading) {
            return Center(
                child: CircularProgressIndicator(
              color: AppColor.primary,
              strokeCap: StrokeCap.round,
            ));
          }
          return TabBarView(
            children: [
              Builder(
                builder: (context) {
                  if (chatRequests == null) {
                    return Center(
                      child: Text("Search Chat Requests"),
                    );
                  }
                  if (chatRequests!.isEmpty) {
                    return Center(
                      child: Text("No Chat Results Found!"),
                    );
                  }
                  return ListView.builder(
                    itemCount: chatRequests!.length,
                    itemBuilder: (context, index) {
                      return RequestAllViewList(
                        communicationModel: chatRequests![index],
                        viewType: ViewType.Chats,
                      );
                    },
                  );
                },
              ),
              Builder(
                builder: (context) {
                  if (callRequests == null) {
                    return Center(
                      child: Text("Search Call Requests"),
                    );
                  }
                  if (callRequests!.isEmpty) {
                    return Center(
                      child: Text("No Call Results Found!"),
                    );
                  }
                  return ListView.builder(
                    itemCount: callRequests!.length,
                    itemBuilder: (context, index) {
                      return RequestAllViewList(
                        communicationModel: callRequests![index],
                        viewType: ViewType.Calls,
                      );
                    },
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
