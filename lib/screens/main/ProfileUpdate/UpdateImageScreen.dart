import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fore_astro_2/Components/ViewImage.dart';
import 'package:fore_astro_2/core/data/api/ApiRequest.dart';
import 'package:fore_astro_2/core/data/repository/profileRepo.dart';
import 'package:fore_astro_2/core/extensions/Text.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:fore_astro_2/core/helper/helper.dart';
import 'package:fore_astro_2/providers/UserProfileProvider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UpdateImageScreen extends StatefulWidget {
  const UpdateImageScreen({super.key});

  @override
  State<UpdateImageScreen> createState() => _UpdateImageScreenState();
}

class _UpdateImageScreenState extends State<UpdateImageScreen> {
  bool loading = false;
  List<File> files = [];
  void pickAfile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
        dialogTitle: "Select Profile Images");
    if (result != null) {
      List<File> sizeImage = [];
      for (var img in result.files) {
        if (((img.size / 1024) / 1024) < 5) {
          sizeImage.add(File(img.path!));
        }
      }

      setState(() {
        files = sizeImage;
      });
    }
  }

  Future saveImage() async {
    try {
      if (files.isNotEmpty) {
        setState(() {
          loading = true;
        });
        List<List<MultipartFile>> imageFiles = [];

        for (var img in files) {
          MultipartFile newfile = await addFormFile(
            img.path,
            filename: img.path.getFileName(),
          );
          imageFiles.add([newfile]);
        }
        Response response =
            await ProfileRepo.astroUpdateProfileImage(imageFiles);
        if (response.data['status'] == true) {
          showToast(response.data['message'] ?? "Profile Successfully Updated");
          context.read<UserProfileProvider>().reloadProfile();
          navigateme.pop();
        } else {
          showToast(response.data['message'] ??
              "Profile Not Updated. Try Again Later");
        }
      } else {
        navigateme.pop();
      }
      setState(() {
        loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        loading = false;
      });
      showToast(toastError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Profile Picture".toUpperCase()),
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Center(
            child: GestureDetector(
              onTap: pickAfile,
              child: Builder(builder: (context) {
                if (files.isNotEmpty) {
                  return Stack(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.file(
                            File(files.first.path),
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          )),
                      Builder(builder: (context) {
                        if (files.length == 1) {
                          return SizedBox();
                        }
                        return Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            width: 40,
                            height: 40,
                            child: Center(
                                child: Text(
                              "${files.length - 1}+",
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            )),
                          ),
                        );
                      }),
                    ],
                  );
                }
                return viewImage(
                    url: context
                        .watch<UserProfileProvider>()
                        .userProfileModel
                        ?.profileImg,
                    boxDecoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100)),
                    width: 120,
                    height: 120);
              }),
            ),
          ),
           Padding(
            padding: EdgeInsets.all(30.0),
            child: Text(
              'Supported file formats: png, jpg, jpeg maximum file size upto 5 mb',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Color(0xFF515151),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        height: 60,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
                onPressed: loading
                    ? null
                    : () {
                        navigateme.pop();
                      },
                child:  Text(
                  "Cancel",
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                )),
            const SizedBox(width: 20),
            SizedBox(
              width: 190,
              child: ElevatedButton(
                onPressed: loading ? null : saveImage,
                child: Text(loading ? "Uploading.." : "Send For Review"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
