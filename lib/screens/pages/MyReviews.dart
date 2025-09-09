import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fore_astro_2/Components/RateingBox.dart';
import 'package:fore_astro_2/core/data/model/ReviewModel.dart';
import 'package:fore_astro_2/core/data/repository/profileRepo.dart';
import 'package:fore_astro_2/core/extensions/window.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';

class MyReviews extends StatefulWidget {
  const MyReviews({super.key});

  @override
  State<MyReviews> createState() => _MyReviewsState();
}

class _MyReviewsState extends State<MyReviews> {
  List<ReviewsModel> data = [];
  bool loading = true;

  @override
  void initState() {
    grtReviews();
    super.initState();
  }

  Future grtReviews() async {
    try {
      Response revews = await ProfileRepo.myReviews();
      if (revews.data['status'] == true) {
        setState(() {
          data = List.generate(revews.data['data'].length,
              (index) => ReviewsModel.fromJson(revews.data['data'][index]));
          loading = false;
        });
      } else {
        setState(() {
          data = [];
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        data = [];
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ratings and Reviews".toUpperCase()),
      ),
      body: SingleChildScrollView(
        child: Builder(
          builder: (context) {
            if (loading) {
              return SizedBox(
                height: context.windowHeight - 200,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColor.primary,
                    strokeCap: StrokeCap.round,
                  ),
                ),
              );
            }
            if (data.isEmpty) {
              return SizedBox(
                height: context.windowHeight - 200,
                child: Center(
                  child: Text("No Reviews"),
                ),
              );
            }
            if (data.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(15),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: RatingReviewBox(
                        reviewsModel: data[index],
                      ),
                    );
                  },
                ),
              );
            }
            return SizedBox(
              height: context.windowHeight - 200,
              child: Center(
                child: Text("No Reviews"),
              ),
            );
          },
        ),
      ),
    );
  }
}
