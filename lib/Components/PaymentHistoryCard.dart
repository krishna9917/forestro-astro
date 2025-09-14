import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fore_astro_2/Components/AccptedRequest.dart';
import 'package:fore_astro_2/Components/ViewImage.dart';
import 'package:fore_astro_2/core/data/model/PaymentHistoryModel.dart';
import 'package:fore_astro_2/core/extensions/Text.dart';
import 'package:fore_astro_2/core/extensions/window.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:fore_astro_2/providers/sockets/socketProvider.dart';
import 'package:fore_astro_2/screens/pages/user/UserProfileScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentListCard extends StatelessWidget {
  final PaymentHistoryModel log;

  const PaymentListCard({
    super.key,
    required this.log,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: GestureDetector(
        onTap: () {
          navigateme.push(routeMe(UserProfileScreen(log: log)));
        },
        child: Container(
          color: Colors.transparent,
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
                          boxDecoration:
                              const BoxDecoration(color: Colors.white),
                          radius: 100,
                          width: 50,
                          height: 50,
                        ),
                      ),
                      Positioned(
                        bottom: -5,
                        right: -5,
                        child: Container(
                          child:
                              requestImage(getRequestType(log.type.toString())),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(width: 15),
                  Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: context.windowWidth - 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  log.name.toString().capitalize(),
                                  style:  GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "₹ ${log.totalAmount}",
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.inter(
                                    color: Color(0xFF201F1F),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                log.time.toString(),
                                style: GoogleFonts.inter(fontSize: 12),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                log.date.toString(),
                                style: GoogleFonts.inter(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
