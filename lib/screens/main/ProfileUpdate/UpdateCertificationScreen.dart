import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_astro_2/constants/Assets.dart';
import 'package:fore_astro_2/constants/ListofData.dart';
import 'package:fore_astro_2/core/data/api/ApiRequest.dart';
import 'package:fore_astro_2/core/data/model/UserProfileModel.dart';
import 'package:fore_astro_2/core/data/repository/profileRepo.dart';
import 'package:fore_astro_2/core/extensions/Text.dart';
import 'package:fore_astro_2/core/extensions/window.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:fore_astro_2/core/helper/helper.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:fore_astro_2/providers/UserProfileProvider.dart';
import 'package:fore_astro_2/screens/main/ProfileUpdate/Preview/PreviewDocsScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class UpdateCertificationScreen extends StatefulWidget {
  const UpdateCertificationScreen({super.key});

  @override
  State<UpdateCertificationScreen> createState() =>
      _UpdateCertificationScreenState();
}

class _UpdateCertificationScreenState extends State<UpdateCertificationScreen> {
  late List<Certifications> certifications;
  bool loading = false;
  @override
  void initState() {
    certifications =
        context.read<UserProfileProvider>().userProfileModel?.certifications ??
            [];
    super.initState();
  }

  Future deleteCertificate(id, index) async {
    try {
      setState(() {
        certifications.removeAt(index);
      });
      await ProfileRepo.astroCertifyDelete(id);
      context.read<UserProfileProvider>().reloadProfile();
    } catch (e) {
      showToast("certificate Delete Failed. Try again later");
    }
  }

  Future uploadCertificateNew() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: certificatesExt,
        allowMultiple: false,
      );
      if (result != null) {
        setState(() {
          loading = true;
        });
        MultipartFile multipartFile = await addFormFile(
          result.files.first.path.toString(),
        );
        Response response = await ProfileRepo.uploadCertificate(multipartFile);
        showToast("Certification Upload Successfully");
        context.read<UserProfileProvider>().reloadProfile();
        navigateme.pop();
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
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
        title: Text("Certification".toUpperCase()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
             Text(
              'Supported file formats: pdf, png, jpg, jpeg maximum file size up to 25 MB',
              style: GoogleFonts.inter(
                color: Color(0xFF515151),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 30),
            Builder(
              builder: (context) {
                if (certifications.isEmpty) {
                  return SizedBox(
                      height: context.windowHeight - 330,
                      child:
                          const Center(child: Text("No Certification Found!")));
                }
                return const SizedBox();
              },
            ),
            Column(
              children: List.generate(
                certifications.length,
                (index) => GestureDetector(
                  onTap: () {
                    navigateme.push(routeMe(
                        PreviewScreen(certification: certifications[index])));
                  },
                  child: FileViewBox(
                    title: certifications[index]
                        .certificate
                        .toString()
                        .getFileName(),
                    desc:
                        '${certifications[index].fileSize != null ? (int.parse(certifications[index].fileSize.toString()) / 1024).round().toString() + " Kb" : certifications[index].certificate.toString().getFileExtension() + " File"}',
                    onPressed: () => deleteCertificate(
                        certifications[index].certificateId, index),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: 65,
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: loading ? null : uploadCertificateNew,
            child: Text(loading ? "Uploading..." : "Upload Certification"),
          ),
        ),
      ),
    );
  }
}

class FileViewBox extends StatelessWidget {
  final String title;
  final String desc;
  void Function()? onPressed;
  FileViewBox({
    super.key,
    required this.title,
    required this.desc,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: context.windowWidth,
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              width: 2,
              color: const Color(0xFFECE7E4),
            ),
          ),
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.file,
                color: AppColor.primary,
              ),
              const SizedBox(width: 18),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: context.windowWidth / 2,
                    child: Text(
                      "$title",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:  GoogleFonts.inter(
                        color: Color(0xFF515151),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    " $desc",
                    style: GoogleFonts.inter(
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
              onPressed: onPressed,
              icon: SvgPicture.asset(
                AssetsPath.bucketIconSvg,
                width: 18,
                height: 18,
              )),
        )
      ],
    );
  }
}
