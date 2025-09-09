import 'package:flutter/material.dart';
import 'package:fore_astro_2/core/extensions/window.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';

class HomeTitleBar extends StatelessWidget {
  final String title;
  final String? desc;
  final bool showViewAll;
  final void Function()? onClick;

  const HomeTitleBar({
    super.key,
    required this.title,
    this.onClick,
    this.desc,
    this.showViewAll = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$title".toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Builder(builder: (context) {
                if (desc == null) {
                  return SizedBox();
                }
                return SizedBox(
                    width: context.windowWidth - 140,
                    child: Text(
                      "$desc",
                      style: TextStyle(fontSize: 12),
                    ));
              }),
            ],
          ),
          Builder(builder: (context) {
            if (showViewAll == false) {
              return SizedBox();
            }
            return GestureDetector(
              onTap: onClick,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                decoration: BoxDecoration(
                    color: AppColor.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(50)),
                child: Text(
                  "View All",
                  style: TextStyle(color: AppColor.primary),
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
