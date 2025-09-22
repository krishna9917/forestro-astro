import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fore_astro_2/Components/ViewImage.dart';
import 'package:fore_astro_2/constants/Assets.dart';
import 'package:fore_astro_2/core/data/model/CommunicationModel.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:fore_astro_2/core/utils/AlertHelper.dart';
import 'package:fore_astro_2/providers/ComunicationProvider.dart';
import 'package:fore_astro_2/providers/UserProfileProvider.dart';
import 'package:fore_astro_2/providers/sockets/socketProvider.dart';
import 'package:fore_astro_2/screens/Comunication/Chat/PreviewChatScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';

enum RequestType { Video, Audio, Chat, Live, None }

class RecquestBox extends StatelessWidget {
  final CommunicationModel communicationModel;
  RequestType isCall;

  void Function()? onOkPress;
  void Function()? onRejectPress;

  RecquestBox(
      {this.isCall = RequestType.None,
      super.key,
      required this.communicationModel,
      this.onOkPress,
      this.onRejectPress});

  ifOkpress(BuildContext context) {
    final isOnline = context
            .read<UserProfileProvider>()
            .userProfileModel
            ?.isOnline
            ?.toString()
            .toLowerCase() ==
        "online";

    if (!isOnline) {
      showAlertPopup(
        context,
        title: "Offline",
        text:
            "Dear Astrologer, bring your expertise online! Online your profile now to start receiving astrology service requests.",
        type: QuickAlertType.warning,
        confirmBtnText: "Online",
        showCancelBtn: true,
        onConfirmBtnTap: () {
          Navigator.pop(context); // Close the popup
          context.read<UserProfileProvider>().toggleOnline(true);
        },
      );
      return;
    }
    print("comunucationnnnnnnnnnn: ${communicationModel.toJson()}");
    // Proceed with accepting the call
    print("go to socket ========================");
    context.read<SocketProvider>().acceptORrejectRequest(
      "accept",
      senderId: communicationModel.userId.toString(),
      requestType: communicationModel.type!,
      communicationId: communicationModel.id.toString(),
      status: "accept",
      communicationModel: communicationModel,
      data: {
        "astroName": context.read<UserProfileProvider>().userProfileModel?.name,
        "astroData":
            context.read<UserProfileProvider>().userProfileModel?.toJson(),
      },
    );
  }

  ifRejectPress(BuildContext context) {
    showAlertPopup(context,
        title: "Are you Sure?",
        text: "You Are Decline This Request",
        type: QuickAlertType.confirm,
        confirmBtnText: "Reject",
        showCancelBtn: true, onConfirmBtnTap: () {
      context.read<SocketProvider>().acceptORrejectRequest(
            "reject",
            senderId: communicationModel.userId.toString(),
            requestType: communicationModel.type!,
            data: {
              "astroName":
                  context.read<UserProfileProvider>().userProfileModel?.name,
              "astroData": context
                  .read<UserProfileProvider>()
                  .userProfileModel
                  ?.toJson(),
            },
            communicationId: communicationModel.id.toString(),
            status: "reject",
            communicationModel: communicationModel,
          );
      navigateme.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      height: 230,
      padding: const EdgeInsets.all(15),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFFFE4D3)),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  if (communicationModel.type == "chat") {
                    navigateme.push(
                      routeMe(
                        PreviewChatScreen(
                          id: communicationModel.userId.toString() +
                              "-user".toString(),
                        ),
                      ),
                    );
                  }
                },
                child: viewImage(
                    boxDecoration: const BoxDecoration(),
                    width: 80,
                    height: 80,
                    url: communicationModel.profilePic),
              ),
              const SizedBox(height: 15),
              Text(
                communicationModel.name!,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: Color(0xFF201F1F),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Date ${communicationModel.date.toString()}',
                    style: GoogleFonts.inter(
                      color: Color(0xFF515151),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Time ${communicationModel.time}',
                    style: GoogleFonts.inter(
                      color: Color(0xFF515151),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Consumer<CommunicationProvider>(builder: (context, state, child) {
                if (communicationModel.slot != state.currentSlots) {
                  return Container(
                    width: 200,
                    height: 30,
                    decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text(
                            "In Waiting - ${(communicationModel.slot! + 1)}",
                            style: GoogleFonts.inter(
                              color: Colors.white,
                            ))),
                  );
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 85,
                      height: 35,
                      child: ElevatedButton(
                        onPressed: onOkPress ?? () => ifOkpress(context),
                        style: ButtonStyle(
                          padding:
                              const WidgetStatePropertyAll(EdgeInsets.all(0)),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        child: Text(
                          isCall != RequestType.None
                              ? isCall == RequestType.Chat
                                  ? "Reply"
                                  : "Accept"
                              : "Reply",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 85,
                      height: 35,
                      child: ElevatedButton(
                        onPressed:
                            onRejectPress ?? () => ifRejectPress(context),
                        style: ButtonStyle(
                            backgroundColor:
                                const WidgetStatePropertyAll(Color(0xFFECE7E4)),
                            padding:
                                const WidgetStatePropertyAll(EdgeInsets.all(0)),
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)))),
                        child: Text(
                          "Decline",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              })
            ],
          ),
          Builder(builder: (context) {
            if (isCall == RequestType.Audio) {
              return Positioned(
                  top: 0,
                  right: 0,
                  child: SvgPicture.asset(
                    AssetsPath.audioCallIconSvg,
                    width: 20,
                    height: 20,
                  ));
            } else if (isCall == RequestType.Video) {
              return Positioned(
                  top: 0,
                  right: 0,
                  child: SvgPicture.asset(
                    AssetsPath.videoCallIconSvg,
                    width: 15,
                    height: 15,
                  ));
            } else if (isCall == RequestType.Chat) {
              return Positioned(
                  top: 0,
                  right: 0,
                  child: SvgPicture.asset(
                    AssetsPath.chatIconSvg,
                    width: 15,
                    height: 15,
                  ));
            } else {
              return const SizedBox();
            }
          }),
        ],
      ),
    );
  }
}
