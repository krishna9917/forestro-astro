import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fore_astro_2/constants/Assets.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';

Widget AppBottamNavBar(int tabindex, {void Function(int)? onTap}) {
  return BottomNavigationBar(currentIndex: 0, onTap: onTap, items: [
    BottomNavigationBarItem(
        icon: SvgPicture.asset(
          AssetsPath.homeIconSvg,
          color: tabindex == 0 ? AppColor.primary : Colors.grey,
          width: 20,
          height: 20,
        ),
        label: "Home"),
    BottomNavigationBarItem(
        icon: SvgPicture.asset(
          AssetsPath.dashbordIconSvg,
          color: tabindex == 1 ? AppColor.primary : Colors.grey,
          width: 20,
          height: 20,
        ),
        label: "Dashboard"),
    BottomNavigationBarItem(
        icon: SvgPicture.asset(
          AssetsPath.liveIconSvg,
          color: tabindex == 2 ? AppColor.primary : Colors.grey,
          width: 20,
          height: 20,
        ),
        label: "Live"),
    BottomNavigationBarItem(
        icon: SvgPicture.asset(
          AssetsPath.profileIconSvg,
          color: tabindex == 3 ? AppColor.primary : Colors.grey,
          width: 20,
          height: 20,
        ),
        label: "Profile"),
  ]);
}
