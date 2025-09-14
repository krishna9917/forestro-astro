import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fore_astro_2/constants/Assets.dart';
import 'package:fore_astro_2/core/data/api/ApiRequest.dart';
import 'package:fore_astro_2/core/data/model/BankModel.dart';
import 'package:fore_astro_2/core/data/repository/bankRepo.dart';
import 'package:fore_astro_2/core/extensions/Text.dart';
import 'package:fore_astro_2/core/extensions/window.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:fore_astro_2/core/helper/helper.dart';
import 'package:fore_astro_2/providers/bankAccoutProvider.dart';
import 'package:fore_astro_2/screens/main/ProfileUpdate/AddNackAccountScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyBackList extends StatelessWidget {
  final BankModel bankModel;
  MyBackList({super.key, required this.bankModel});

  void deleteBank(BuildContext context) async {
    try {
      Response response = await BankRepo.deleteBankAccounts(bankModel.id);
      if (response.data['status'] == true) {
        showToast(response.data['message'] ?? "Bank Delete Successfully");
        context.read<BankAccountProvider>().loadBankdata();
      } else {
        showToast(toastError);
      }
    } catch (e) {
      showToast("Error On Delete Bank Account");
    }
  }

  void setAsPrimary(BuildContext context) async {
    try {
      showToast("Switching Your Primary Account");
      Response response = await BankRepo.setPrimaryBankAccounts(bankModel.id);
      if (response.data['status'] == true) {
        showToast("Changed Primary Bank Successfully");
        context.read<BankAccountProvider>().loadBankdata();
      } else {
        showToast(toastError);
      }
    } catch (e) {
      showToast("Error On Delete Bank Account");
    }
  }

  final GlobalKey _menuMangeKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final button = PopupMenuButton(
        key: _menuMangeKey,
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        icon: const Icon(Icons.more_horiz_rounded),
        itemBuilder: (_) => const <PopupMenuItem<String>>[
              PopupMenuItem<String>(
                value: 'primary',
                child: Text('Set Primary Account'),
              ),
              PopupMenuItem<String>(
                value: 'edit',
                child: Text('Edit Bank Account'),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: Text('Delete Bank Account'),
              ),
            ],
        onSelected: (e) {
          switch (e) {
            case "primary":
              setAsPrimary(context);
              break;
            case "edit":
              navigateme.push(routeMe(AddBankAccountScreen(
                bankModel: bankModel,
              )));
              break;
            case "delete":
              deleteBank(context);
              break;
            default:
              print("Nothing");
          }
        });

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              navigateme.push(routeMe(AddBankAccountScreen(
                bankModel: bankModel,
              )));
            },
            child: Container(
              width: context.windowWidth,
              padding: const EdgeInsets.all(16),
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
                children: [
                  Text(
                    '${bankModel.name.toString().firstCharacters(30)}  ${bankModel.accountNumber.toString().lastCharacters(4)}',
                    style:  GoogleFonts.inter(
                      color: Color(0xFF201F1F),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    bankModel.status == "1"
                        ? 'Primary Account'
                        : "Other Account",
                    style: GoogleFonts.inter(
                      color: Color(0xFF515151),
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          Builder(builder: (context) {
            if (bankModel.status != "1") {
              return const SizedBox();
            }
            return const Positioned(
              right: 12,
              top: 12,
              child: Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 18,
              ),
            );
          }),
          Positioned(
            right: 0,
            bottom: -5,
            child: button,
          )
        ],
      ),
    );
  }
}

class AddNewBank extends StatelessWidget {
  const AddNewBank({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
        dashPattern: [8, 5],
        color: Color.fromARGB(255, 195, 195, 195),
        borderType: BorderType.RRect,
        radius: Radius.circular(30),
        padding: EdgeInsets.all(5),
        strokeWidth: 2,
        child: Container(
          width: context.windowWidth,
          height: 80,
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                AssetsPath.bankIconSvg,
                width: 30,
                height: 30,
              ),
              SizedBox(width: 25),
              Text(
                'Add Bank Account',
                style: GoogleFonts.inter(
                  color: Color(0xFFFF6600),
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ));
  }
}
