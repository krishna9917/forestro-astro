import 'package:flutter/material.dart';
import 'package:fore_astro_2/Components/AccptedRequest.dart';
import 'package:fore_astro_2/Components/HomeTitleBar.dart';
import 'package:fore_astro_2/Components/RequestBox.dart';
import 'package:fore_astro_2/Components/ViewImage.dart';
import 'package:fore_astro_2/core/extensions/window.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:fore_astro_2/providers/ComunicationProvider.dart';
import 'package:fore_astro_2/providers/UserProfileProvider.dart';
import 'package:fore_astro_2/providers/sockets/socketProvider.dart';
import 'package:fore_astro_2/screens/Comunication/search/SearchRequest.dart';
import 'package:fore_astro_2/screens/Comunication/viewAll/ViewAllRequestScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return RefreshIndicator(
      color: AppColor.primary,
      onRefresh: () async {
        await context.read<CommunicationProvider>().reloadComunication();
      },
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                readOnly: true,
                textCapitalization: TextCapitalization.words,
                onTap: () {
                  navigateme.push(routeMe(const SearchRequestScreen()));
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "   Search for Request",
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(Icons.search),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(
                      width: 2,
                      color: Color(0xFFECE7E4),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColor.primary,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    "This Week ${context.watch<UserProfileProvider>().userProfileModel?.score?.split(" ").first ?? '0'}",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.03,
                    ),
                  ),
                ),
              ),
            ),
            Consumer<CommunicationProvider>(builder: (context, state, child) {
              if (state.calls == null || state.calls == null) {
                return SizedBox(
                  height: 500,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColor.primary,
                      strokeCap: StrokeCap.round,
                      strokeWidth: 3,
                    ),
                  ),
                );
              }
              if (state.calls!.isEmpty && state.chats!.isEmpty) {
                return SizedBox(
                  height: 400,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'No Chat Or Call Request Today',
                          style: GoogleFonts.inter(
                            color: Color(0xFF201F1F),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'Our team will review your profile and notify you once it has been approved. Thank you for your patience.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: Color(0xFF515151),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            state.reloadComunication(isReload: true);
                          },
                          child: state.reloading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                    strokeCap: StrokeCap.round,
                                  ),
                                )
                              : const Text("Reload"),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Builder(builder: (context) {
                    if (state.chats!.isEmpty) {
                      return const SizedBox();
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HomeTitleBar(
                          title: "Chat Request",
                          onClick: () {
                            navigateme.push(
                              routeMe(
                                const ViewAllRequestScreen(
                                  viewType: ViewType.Chats,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ...List.generate(
                                  state.chats!.length,
                                  (index) => Row(
                                        children: [
                                          const SizedBox(width: 20),
                                          RecquestBox(
                                            isCall: RequestType.None,
                                            communicationModel:
                                                state.chats![index],
                                          ),
                                        ],
                                      )),
                              const SizedBox(width: 20),
                            ],
                          ),
                        )
                      ],
                    );
                  }),
                  const SizedBox(height: 20),
                  Builder(builder: (context) {
                    if (state.calls!.isEmpty) {
                      return const SizedBox();
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HomeTitleBar(
                          title: "Call Request",
                          onClick: () {
                            navigateme.push(routeMe(const ViewAllRequestScreen(
                              viewType: ViewType.Calls,
                            )));
                          },
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ...List.generate(
                                  state.calls!.length,
                                  (index) => Row(
                                        children: [
                                          const SizedBox(width: 20),
                                          RecquestBox(
                                            isCall: state.calls?[index].type ==
                                                    "video"
                                                ? RequestType.Video
                                                : RequestType.Audio,
                                            communicationModel:
                                                state.calls![index],
                                          ),
                                        ],
                                      )),
                              const SizedBox(width: 20),
                            ],
                          ),
                        )
                      ],
                    );
                  }),
                ],
              );
            }),
            const SizedBox(height: 20),
            Consumer<CommunicationProvider>(builder: (context, data, child) {
              if (data.todayLogs == null) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: List.generate(
                      2,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Opacity(
                          opacity: 0.5,
                          child: viewShimmer(
                              width: context.windowWidth,
                              height: 100,
                              radius: 10),
                        ),
                      ),
                    ),
                  ),
                );
              } else if (data.todayLogs!.isEmpty) {
                return const SizedBox();
              }
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HomeTitleBar(
                      title: "Today Requests",
                      showViewAll: false,
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.todayLogs?.length,
                        itemBuilder: (context, index) {
                          return AccptedRequest(
                            image: data.todayLogs![index].profilePic.toString(),
                            name: data.todayLogs![index].name.toString(),
                            status: data.todayLogs![index].status.toString(),
                            id: data.todayLogs![index].userId.toString(),
                            dateTime:
                                "${data.todayLogs![index].date}    ${data.todayLogs![index].time}",
                            requestType: getRequestType(
                              data.todayLogs![index].type.toString(),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
