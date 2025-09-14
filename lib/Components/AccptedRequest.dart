import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fore_astro_2/Components/RequestBox.dart';
import 'package:fore_astro_2/Components/ViewImage.dart';
import 'package:fore_astro_2/constants/Assets.dart';
import 'package:fore_astro_2/core/extensions/Text.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:fore_astro_2/screens/Comunication/Chat/PreviewChatScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class AccptedRequest extends StatelessWidget {
  RequestType requestType;
  String image;
  String name;
  String dateTime;
  String id;
  String status;
  AccptedRequest({
    super.key,
    this.requestType = RequestType.None,
    required this.dateTime,
    required this.image,
    required this.name,
    required this.status,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(id);
        if (requestType == RequestType.Chat) {
          navigateme.push(routeMe(PreviewChatScreen(id: "$id-user")));
        }
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                viewImage(
                    url: image,
                    boxDecoration: const BoxDecoration(),
                    width: 50,
                    height: 50),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        '$name',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: Color(0xFF313131),
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$dateTime',
                          style: GoogleFonts.inter(
                            color: Color(0xFF908686),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 10),
                        requestImage(requestType),
                      ],
                    )
                  ],
                )
              ],
            ),
            Text(
              '$status'.capitalize(),
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(
                color: Color(0xFF515151),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget requestImage(RequestType requestType,
    {double width = 14, double height = 14}) {
  return Builder(builder: (context) {
    if (requestType == RequestType.Chat) {
      return SvgPicture.asset(
        AssetsPath.chatIconSvg,
        width: width,
        height: height,
      );
    } else if (requestType == RequestType.Video) {
      return SvgPicture.asset(
        AssetsPath.videoCallIconSvg,
        width: width,
        height: height,
      );
    } else if (requestType == RequestType.Audio) {
      return SvgPicture.asset(
        AssetsPath.audioCallIconSvg,
        width: width,
        height: height,
      );
    }
    return const SizedBox();
  });
}
