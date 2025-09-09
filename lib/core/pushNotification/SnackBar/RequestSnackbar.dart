import 'package:flutter/material.dart';
import 'package:fore_astro_2/Components/AccptedRequest.dart';
import 'package:fore_astro_2/Components/RequestBox.dart';
import 'package:fore_astro_2/Components/ViewImage.dart';
import 'package:fore_astro_2/core/extensions/Text.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';

SnackBar SnackBarBox(
    {required RequestType requestType,
    required String name,
    required String image,
    required String type,
    required String user_wallet,
    void Function()? onTap}) {
  return SnackBar(
    elevation: 0.3,
    content: SizedBox(
      height: 50,
      child: Stack(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  viewImage(
                    width: 40,
                    height: 40,
                    boxDecoration: BoxDecoration(),
                    url: image,
                  ),
                  Positioned(
                    right: -5,
                    bottom: -5,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: requestImage(requestType),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        "$name".capitalize(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            color: AppColor.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      "Sent ${type.capitalize()} Request".capitalize(),
                      style: const TextStyle(
                          color: Color(0xFF353433),
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            top: 5,
            child: GestureDetector(
              onTap: () {
                snackbarKey.currentState?.hideCurrentSnackBar();
                if (onTap != null) {
                  onTap();
                }
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: AppColor.bgcolor,
                ),
                child: Icon(
                  Icons.close,
                  color: AppColor.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    backgroundColor: Colors.white,
    behavior: SnackBarBehavior.floating,
    dismissDirection: DismissDirection.endToStart,
    duration: Duration(seconds: 3),
    shape: RoundedRectangleBorder(
      side: BorderSide(width: 1, color: AppColor.primary.withOpacity(0.4)),
    ),
  );
}
