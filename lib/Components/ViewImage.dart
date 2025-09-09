import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:shimmer/shimmer.dart';

Widget viewImage(
    {double height = 60,
    String? url,
    String? name,
    double width = 60,
    BoxDecoration? boxDecoration,
    TextStyle? textStyle,
    double radius = 100}) {
  return Container(
    decoration: boxDecoration ??
        BoxDecoration(
          color: Color.fromARGB(255, 249, 248, 240),
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            width: 2,
            color: AppColor.primary,
          ),
        ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Builder(builder: (context) {
        if (url == null) {
          return Container(
            height: height,
            width: width,
            decoration: boxDecoration ??
                BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(radius),
                  border: Border.all(
                    width: 1,
                    color: AppColor.primary,
                  ),
                ),
            child: Center(
              child: Text(
                (name ?? "U").split("")[0].toUpperCase(),
                style: textStyle ??
                    const TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 111, 100, 100),
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          );
        }
        return CachedNetworkImage(
          imageUrl: url,
          width: width,
          height: height,
          fit: BoxFit.cover,
          placeholder: (context, url) => viewShimmer(
            height: height,
            width: width,
            boxDecoration: boxDecoration,
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.red,
            width: width,
            height: height,
            child: Icon(
              Icons.error,
              size: width / 5,
              color: Colors.white,
            ),
          ),
        );
      }),
    ),
  );
}

Widget viewShimmer(
    {double height = 100,
    double width = 100,
    BoxDecoration? boxDecoration,
    double radius = 0}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: SizedBox(
      width: width,
      height: height,
      child: Shimmer.fromColors(
        baseColor: Color.fromARGB(255, 255, 255, 255),
        highlightColor: const Color.fromARGB(255, 233, 233, 233),
        child: Container(
          width: width,
          height: height,
          decoration: boxDecoration ??
              const BoxDecoration(
                color: Colors.white,
              ),
        ),
      ),
    ),
  );
}
