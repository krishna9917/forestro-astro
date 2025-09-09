import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fore_astro_2/Components/ViewImage.dart';
import 'package:fore_astro_2/core/data/model/FollowersModel.dart';
import 'package:fore_astro_2/core/data/repository/profileRepo.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:fore_astro_2/screens/pages/kundli/KundliForm.dart';

class MyFollowersScreen extends StatefulWidget {
  const MyFollowersScreen({super.key});

  @override
  State<MyFollowersScreen> createState() => _MyFollowersScreenState();
}

class _MyFollowersScreenState extends State<MyFollowersScreen> {
  List<MyFollowerModel>? followers;
  bool loading = true;
  loadFollwers() async {
    try {
      Response data = await ProfileRepo.getFollowers();
      List<MyFollowerModel> followersModel = List.generate(
        data.data['data'].length,
        (index) => MyFollowerModel.fromJson(
          data.data['data'][index],
        ),
      );

      setState(() {
        loading = false;
        followers = followersModel;
      });
    } catch (e) {
      setState(() {
        loading = false;
        followers = [];
      });
    }
  }

  @override
  void initState() {
    loadFollwers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Followers".toUpperCase()),
        centerTitle: true,
      ),
      body: Builder(builder: (context) {
        if (loading) {
          return Center(
            child: CircularProgressIndicator(
              strokeCap: StrokeCap.round,
            ),
          );
        }
        if (followers == null || followers!.isEmpty) {
          return Center(
            child: Text("No Followers"),
          );
        }
        return RefreshIndicator(
          color: AppColor.primary,
          onRefresh: () async {
            await loadFollwers();
          },
          child: GridView.builder(
            padding: EdgeInsets.all(5),
            itemCount: followers!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemBuilder: (context, index) {
              MyFollowerModel follower = followers![index];
              return GestureDetector(
                onTap: () {
                  print(follower.id);
                  navigateme.push(routeMe(KundliForm(
                    id: follower.id!,
                    name: follower.userName,
                  )));
                },
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      viewImage(
                        url: follower.profileImg,
                        name: follower.userName,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          follower.userName!,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
