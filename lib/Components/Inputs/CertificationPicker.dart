import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_astro_2/constants/Assets.dart';
import 'package:fore_astro_2/constants/ListofData.dart';
import 'package:fore_astro_2/core/extensions/window.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:google_fonts/google_fonts.dart';

class CertificationPicker extends StatefulWidget {
  Function(List<PlatformFile>)? onSelect;
  CertificationPicker({super.key, this.onSelect});

  @override
  State<CertificationPicker> createState() => _CertificationPickerState();
}

class _CertificationPickerState extends State<CertificationPicker> {
  List<PlatformFile> files = [];

  void pickAFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: certificatesExt,
      allowCompression: true,
    );

    if (result != null) {
      if (widget.onSelect != null) {
        widget.onSelect!(result.files);
      }

      setState(() {
        files = result.files;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Padding(
            padding: EdgeInsets.only(left: 10, bottom: 8, top: 15),
            child: Text(
              "Certification",
              style: GoogleFonts.inter(
                color: Color(0xFF353333),
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          DottedBorder(
            color: const Color(0xFFECE7E4),
            strokeWidth: 2,
            strokeCap: StrokeCap.round,
            borderType: BorderType.RRect,
            radius: const Radius.circular(30),
            dashPattern: [8, 5],
            child: Container(
              width: context.windowWidth,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: pickAFile,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7E7E7),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Icons.file_upload_outlined,
                        color: AppColor.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                   Text(
                    'Upload New File',
                    style: GoogleFonts.inter(
                      color: Color(0xFFFF6600),
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                   Text(
                    '(Max. file size: 25 MB)',
                    style: GoogleFonts.inter(
                      color: Color(0xFF515151),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          ListView.builder(
            itemCount: files.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Container(
                    width: context.windowWidth,
                    margin: EdgeInsets.only(bottom: 15),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        width: 2,
                        color: Color(0xFFECE7E4),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.filePdf,
                          color: AppColor.primary,
                        ),
                        SizedBox(width: 18),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: context.windowWidth / 2,
                              child: Text(
                                files[index].name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Color(0xFF515151),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              "${(files[index].size / 1024).round()} Kb",
                              style: TextStyle(
                                color: Color(0xFF908686),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    right: 3,
                    top: 5,
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            files.removeAt(index);
                          });
                          if (widget.onSelect != null) {
                            widget.onSelect!(files);
                          }
                        },
                        icon: SvgPicture.asset(
                          AssetsPath.bucketIconSvg,
                          width: 18,
                          height: 18,
                        )),
                  )
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
