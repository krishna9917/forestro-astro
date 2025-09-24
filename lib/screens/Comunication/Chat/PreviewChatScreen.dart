import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_astro_2/constants/Assets.dart';
import 'package:fore_astro_2/core/data/model/UserProfileModel.dart';
import 'package:fore_astro_2/core/extensions/window.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:fore_astro_2/core/theme/AppTheme.dart';
import 'package:fore_astro_2/screens/main/ProfileUpdate/Preview/PreviewDocsScreen.dart';
import 'package:fore_astro_2/screens/pages/kundli/KundliForm.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class PreviewChatScreen extends StatelessWidget {
  final String id;

  const PreviewChatScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    print("chatid========================================$id");
    return Theme(
      data: appTheme.copyWith(),
      child: ZIMKitMessageListPage(
        key: ValueKey('preview-${id}'),
        // showOnly: true,
        showPickMediaButton: false,
        showMoreButton: false,
        showPickFileButton: false,
        messageInputKeyboardType: TextInputType.none,
        inputBackgroundDecoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        messageListBackgroundBuilder: (context, defaultWidget) {
          return Image.asset(
            AssetsPath.chatBgSvg,
            width: context.windowWidth,
            height: context.windowHeight,
            fit: BoxFit.cover,
          );
        },
        appBarBuilder: (context, defaultAppBar) {
          return AppBar(
            title: defaultAppBar.title,
            actions: [
              IconButton(
                  onPressed: () {
                    navigateme.push(routeMe(KundliForm(
                      id: int.parse(id.split("-")[0]),
                    )));
                  },
                  icon: const Icon(FontAwesomeIcons.info))
            ],
          );
        },
        onMessageItemPressed: (context, message, defaultAction) {
          if (message.type == ZIMMessageType.image) {
            navigateme.push(
              routeMe(
                PreviewScreen(
                  isImage: true,
                  certification: Certifications(
                    certificate: message.imageContent!.fileDownloadUrl,
                    certificateId: DateTime.now().microsecondsSinceEpoch,
                    fileSize: message.imageContent!.fileSize.toString(),
                  ),
                ),
              ),
            );
          }
        },
        onMessageSent: (e) {},
        inputDecoration: const InputDecoration(
          border: InputBorder.none,
          errorBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          enabled: false,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
        ),
        showRecordButton: false,
        conversationID: id,
        conversationType: ZIMConversationType.peer,
      ),
    );
  }
}
