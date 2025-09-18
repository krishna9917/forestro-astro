import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_astro_2/constants/Assets.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:google_fonts/google_fonts.dart';

var outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(25),
  borderSide: BorderSide(width: 1, color: AppColor.primary),
);

var errorOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(25),
  borderSide: BorderSide(width: 1, color: Colors.red),
);

ThemeData appTheme = ThemeData(
    textTheme: GoogleFonts.interTextTheme(),
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: AppColor.bgcolor,
    primaryColor: AppColor.primary,
    checkboxTheme: CheckboxThemeData(
      checkColor: MaterialStatePropertyAll(AppColor.primary),
      fillColor: MaterialStatePropertyAll(AppColor.primary),
      shape: CircleBorder(),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColor.primary,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Colors.white,
        elevation: 0,
        selectedLabelStyle: TextStyle(color: AppColor.primary),
        unselectedLabelStyle: TextStyle(color: Colors.grey)),
    actionIconTheme: ActionIconThemeData(
      drawerButtonIconBuilder: (context) {
        return SvgPicture.asset(
          AssetsPath.navIconSvg,
          width: 15,
          height: 15,
        );
      },
      backButtonIconBuilder: (context) {
        return const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 23,
        );
      },
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: AppColor.bgcolor,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: const MaterialStatePropertyAll(0),
        backgroundColor: MaterialStatePropertyAll(AppColor.primary),
        foregroundColor: MaterialStatePropertyAll(Colors.white),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide.none,
          ),
        ),
        textStyle: const MaterialStatePropertyAll(
          TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: outlineInputBorder,
      enabledBorder: outlineInputBorder,
      focusedErrorBorder: outlineInputBorder,
      errorBorder: errorOutlineInputBorder,
      focusedBorder: outlineInputBorder,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColor.primary,
        selectionColor: AppColor.bgcolor,
        selectionHandleColor: AppColor.primary //thereby
        ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStatePropertyAll(TextStyle(color: AppColor.primary)),
        foregroundColor: MaterialStatePropertyAll(AppColor.primary),
        surfaceTintColor: MaterialStatePropertyAll(Colors.transparent),
        splashFactory: NoSplash.splashFactory,
        enableFeedback: true,
        overlayColor: MaterialStatePropertyAll(Colors.transparent),
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.white,
      elevation: 0.0,
    ),
    bottomAppBarTheme: const BottomAppBarThemeData(
      color: Colors.white,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 0,
      backgroundColor: AppColor.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    ));
