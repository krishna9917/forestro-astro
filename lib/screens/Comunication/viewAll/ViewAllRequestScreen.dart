import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fore_astro_2/Components/AccptedRequest.dart';
import 'package:fore_astro_2/Components/RequestBox.dart';
import 'package:fore_astro_2/Components/ViewImage.dart';
import 'package:fore_astro_2/core/data/model/CommunicationModel.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:fore_astro_2/providers/ComunicationProvider.dart';
import 'package:fore_astro_2/screens/Comunication/Chat/PreviewChatScreen.dart';
import 'package:fore_astro_2/screens/pages/kundli/KundliForm.dart';
import 'package:provider/provider.dart';

enum ViewType { Chats, Calls }

class ViewAllRequestScreen extends StatelessWidget {
  final ViewType viewType;
  const ViewAllRequestScreen({super.key, required this.viewType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Builder(
          builder: (context) {
            if (viewType == ViewType.Chats) {
              return Text("All Chat Requests".toUpperCase());
            } else {
              return Text("All Call Requests".toUpperCase());
            }
          },
        ),
      ),
      body: Consumer<CommunicationProvider>(builder: (context, state, child) {
        if ((viewType == ViewType.Chats ? state.chats ?? [] : state.calls ?? [])
            .isEmpty) {
          return Center(
            child: Text("No Request Found"),
          );
        }
        return ListView.builder(
          itemCount: viewType == ViewType.Chats
              ? state.chats?.length ?? 0
              : state.calls?.length ?? 0,
          itemBuilder: (context, index) {
            CommunicationModel communicationModel = (viewType == ViewType.Chats
                ? state.chats![index]
                : state.calls![index]);

            return RequestAllViewList(
                communicationModel: communicationModel, viewType: viewType);
          },
        );
      }),
    );
  }
}

class RequestAllViewList extends StatelessWidget {
  final CommunicationModel communicationModel;
  final ViewType viewType;
  const RequestAllViewList(
      {super.key, required this.communicationModel, required this.viewType});

  @override
  Widget build(BuildContext context) {
    final GlobalKey _toggleMenuKey = GlobalKey();
    final toggleButtons = PopupMenuButton(
        key: _toggleMenuKey,
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        icon: const Icon(Icons.more_vert_sharp),
        itemBuilder: (_) => <PopupMenuItem<String>>[
              const PopupMenuItem<String>(
                  value: 'kundli', child: Text('View Kundli')),
              PopupMenuItem<String>(
                value: 'accept',
                child:
                    Text(viewType == ViewType.Chats ? 'Send Reply' : "Answer"),
              ),
              const PopupMenuItem<String>(
                  value: 'reject', child: Text('Reject')),
            ],
        onSelected: (v) {
          switch (v) {
            case "kundli":
              navigateme.push(routeMe(KundliForm(
                id: communicationModel.userId!,
                name: communicationModel.name,
              )));
              break;
            case "accept":
              RecquestBox(
                communicationModel: communicationModel,
                isCall: viewType == ViewType.Chats
                    ? RequestType.Chat
                    : communicationModel.type == "video"
                        ? RequestType.Video
                        : RequestType.Audio,
              ).ifOkpress(context);
              break;
            default:
              RecquestBox(
                communicationModel: communicationModel,
                isCall: viewType == ViewType.Chats
                    ? RequestType.Chat
                    : communicationModel.type == "video"
                        ? RequestType.Video
                        : RequestType.Audio,
              ).ifRejectPress(context);
          }
        });

    return ListTile(
      title: Text(
        communicationModel.name.toString(),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        '${communicationModel.date} - ${communicationModel.time}',
        style: TextStyle(fontSize: 12),
      ),
      leading: Stack(
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: viewImage(
                url: communicationModel.profilePic,
                boxDecoration: BoxDecoration()),
          ),
          Positioned(
            right: -5,
            top: -5,
            child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColor.bgcolor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: requestImage(viewType == ViewType.Chats
                    ? RequestType.Chat
                    : communicationModel.type == "video"
                        ? RequestType.Video
                        : RequestType.Audio)),
          ),
        ],
      ),
      trailing: toggleButtons,
      onTap: () {
        if (communicationModel.type == "chat") {
          navigateme.push(
            routeMe(
              PreviewChatScreen(
                id: communicationModel.userId.toString() + "-user".toString(),
              ),
            ),
          );
        }
      },
    );
    ;
  }
}
