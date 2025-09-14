import 'package:flutter/material.dart';
import 'package:fore_astro_2/core/data/model/UserProfileModel.dart';
import 'package:fore_astro_2/core/extensions/Text.dart';
import 'package:fore_astro_2/core/extensions/window.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:google_fonts/google_fonts.dart';

class UserInfoBox extends StatelessWidget {
  final String title;
  final List<Widget> child;
  void Function()? onPressed;
  final bool showEdit;
  final bool showTitle;
  UserInfoBox({
    super.key,
    required this.title,
    required this.child,
    this.onPressed,
    this.showEdit = true,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          width: context.windowWidth,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFECE7E4)),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              showTitle
                  ? Text(
                      '$title',
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : SizedBox(),
              Builder(
                builder: (context) {
                  if (child.isEmpty) {
                    return const Text("Upload Your Certifications");
                  } else {
                    return Column(children: child);
                  }
                },
              ),
            ],
          ),
        ),
        Builder(builder: (context) {
          if (!showEdit) {
            return SizedBox();
          }
          return Positioned(
              top: 8,
              right: 5,
              child: IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    Icons.edit_outlined,
                    color: AppColor.primary,
                    size: 20,
                  )));
        }),
      ],
    );
  }
}

class UserInfoBoxContent extends StatelessWidget {
  final String title;
  final String content;
  final double? width;
  final TextStyle? textStyle;
  const UserInfoBoxContent({
    super.key,
    required this.title,
    this.width,
    required this.content,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      width: width ??
          context.windowWidth / 2 - (context.windowWidth > 600 ? 100 : 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title',
            style: GoogleFonts.inter(
              color: Color(0xFF908686),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '$content',
            style: textStyle ??
                GoogleFonts.inter(
                  color: Color(0xFF201F1F),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
          )
        ],
      ),
    );
  }
}

class UserCertificationBox extends StatelessWidget {
  final Certifications certifications;

  const UserCertificationBox({
    super.key,
    required this.certifications,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              Icons.file_present_rounded,
              size: 20,
              color: AppColor.primary,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${certifications.certificate.toString().getFileName().firstCharacters(20) + certifications.certificate.toString().getFileExtension()}',
                style: GoogleFonts.inter(
                  color: Color(0xFF201F1F),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${certifications.fileSize != null ? (int.parse(certifications.fileSize.toString()) / 1024).round().toString() + " Kb" : certifications.certificate.toString().getFileExtension() + " File"}',
                style: GoogleFonts.inter(
                  color: Color(0xFF908686),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
