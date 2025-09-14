import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/UserProfileProvider.dart';

class WalletBox extends StatelessWidget {
  const WalletBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          Icon(
            FontAwesomeIcons.wallet,
            color: AppColor.primary,
            size: 18,
          ),
          SizedBox(width: 10),
          Text(
            "₹ ${context.watch<UserProfileProvider>().userProfileModel?.wallet}",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
