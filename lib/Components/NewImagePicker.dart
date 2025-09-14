import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_astro_2/constants/Assets.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:google_fonts/google_fonts.dart';

class NewImagePicker extends StatefulWidget {
  final Function(List<File>?)? onSelect;

  const NewImagePicker({
    super.key,
    this.onSelect,
  });

  @override
  State<NewImagePicker> createState() => _NewImagePickerState();
}

class _NewImagePickerState extends State<NewImagePicker> {
  List<File> file = [];
  void pickAFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['jpg', 'png', 'webp', 'jpeg'],
    );
    if (result != null) {
      List<File> _tmpFiles = [];
      for (var file in result.files) {
        if (file.path != null) {
          _tmpFiles.add(File(file.path!));
        }
      }
      if (widget.onSelect != null) {
        widget.onSelect!(_tmpFiles);
      }

      if (_tmpFiles.isNotEmpty) {
        setState(() {
          file = _tmpFiles;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Container(
            color: Colors.white,
            child: Builder(builder: (context) {
              if (file.isNotEmpty) {
                return Image.file(
                  file[0],
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                );
              }
              return Image.asset(
                AssetsPath.personLogo,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              );
            }),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: pickAFile,
            child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Color(0xFFDEDEDE),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Icon(
                    FontAwesomeIcons.edit,
                    size: 12,
                    color: AppColor.primary,
                  ),
                )),
          ),
        ),
        file.isEmpty
            ? SizedBox()
            : Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: pickAFile,
                  child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Color(0xFFDEDEDE),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                          child: Text(
                        "${file.length - 1}+",
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                      ))),
                ),
              )
      ],
    );
  }
}
