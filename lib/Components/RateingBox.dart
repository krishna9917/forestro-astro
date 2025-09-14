import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fore_astro_2/Components/ViewImage.dart';
import 'package:fore_astro_2/core/data/model/ReviewModel.dart';
import 'package:fore_astro_2/core/extensions/Text.dart';
import 'package:fore_astro_2/core/extensions/window.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:google_fonts/google_fonts.dart';

Widget ViewRating({double initialRating = 0.0}) {
  return RatingBar.builder(
    initialRating: 3,
    minRating: 1,
    direction: Axis.horizontal,
    allowHalfRating: true,
    itemCount: 5,
    itemSize: 16,
    unratedColor: AppColor.primary.withOpacity(0.1),
    itemPadding: const EdgeInsets.symmetric(horizontal: 0),
    itemBuilder: (context, _) => const Icon(
      Icons.star,
      color: Colors.amber,
    ),
    onRatingUpdate: (rating) {
      print(rating);
    },
  );
}

class RatingReviewBox extends StatelessWidget {
  final ReviewsModel reviewsModel;
  const RatingReviewBox({
    super.key,
    required this.reviewsModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.windowWidth,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 1,
          color: AppColor.primary.withOpacity(0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  viewImage(
                    url: reviewsModel.userImg,
                    boxDecoration: const BoxDecoration(),
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reviewsModel.userName!,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      ViewRating(
                          initialRating:
                              double.tryParse(reviewsModel.rating.toString()) ??
                                  0),
                    ],
                  )
                ],
              ),
              Text(
                reviewsModel.postDate.toString().formatDate(),
                style: GoogleFonts.inter(fontSize: 12),
              )
            ],
          ),
          Builder(builder: (context) {
            if (reviewsModel.comment == null) {
              return SizedBox();
            }
            return Padding(
              padding: const EdgeInsets.only(top: 15, left: 5, right: 5),
              child: Text(
                reviewsModel.comment.toString(),
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(fontSize: 13),
              ),
            );
          }),
        ],
      ),
    );
  }
}
