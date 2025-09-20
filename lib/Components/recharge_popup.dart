import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/Assets.dart';


homePopup(context) async {

    showDialog(
        context: context,
        builder: (context) {
          return  AlertDialog(
           contentPadding: const EdgeInsets.all(0),
            insetPadding: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.transparent,
            content: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                  decoration: BoxDecoration(
                   image:  DecorationImage(
                      image: AssetImage(AssetsPath.popUpBg),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(20
                    ),),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 30),
                        child: Column(
                          children: [
                             Text(
                              "Recharge now of",
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                             SizedBox(height: 10),
                             Text(
                              "Rs. 49",
                              style: GoogleFonts.inter(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(height: 10),
                             Text(
                              "and instantly get",
                              style: GoogleFonts.inter(fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                             Text(
                              "Rs. 100 in Your Wallet",
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 12),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child:  Text(
                                "Recharge Now",
                                style: GoogleFonts.inter(fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -40,
                  child: Stack(
                    children: [
                      Image.asset(
                        AssetsPath.gift, // Your gift image
                        height: 80,
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }


