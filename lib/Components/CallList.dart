import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_astro_2/Components/AccptedRequest.dart';
import 'package:fore_astro_2/Components/ViewImage.dart';
import 'package:fore_astro_2/core/data/model/LogModel.dart';
import 'package:fore_astro_2/core/extensions/Text.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:fore_astro_2/providers/sockets/socketProvider.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatListCard extends StatelessWidget {
  final LogModel log;
  const ChatListCard({
    super.key,
    required this.log,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: viewImage(
                      url: log.profilePic,
                      boxDecoration: const BoxDecoration(color: Colors.white),
                      radius: 100,
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        child:
                            requestImage(getRequestType(log.type.toString())),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ))
                ],
              ),
              const SizedBox(width: 15),
              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${log.name?[0].toUpperCase()}${log.name?.substring(1)}",
                        style:GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${log.communicitionTime} mins",
                            style: GoogleFonts.inter(fontSize: 12),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Amount ₹ ${log.totalAmount}",
                            style: GoogleFonts.inter(fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text.rich(
                            TextSpan(
                                text: '${log.type.toString().capitalize()} ID:',
                                children: <InlineSpan>[
                                  TextSpan(
                                    text:
                                        ' ${log.communicationId}'.toUpperCase(),
                                    style: GoogleFonts.inter(
                                        color: AppColor.primary, fontSize: 13),
                                  ),
                                ]),
                          ),
                          const SizedBox(width: 20),
                          Text.rich(
                            TextSpan(text: 'ID:', children: <InlineSpan>[
                              TextSpan(
                                text: '${log.id}'.toUpperCase(),
                                style: GoogleFonts.inter(color: AppColor.primary),
                              ),
                            ]),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
