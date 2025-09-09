import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fore_astro_2/Components/Inputs/CompleteProfileInputBox.dart';
import 'package:fore_astro_2/core/data/repository/profileRepo.dart';
import 'package:fore_astro_2/core/extensions/window.dart';
import 'package:fore_astro_2/core/helper/helper.dart';

class RaiseAnIssuePage extends StatefulWidget {
  const RaiseAnIssuePage({super.key});

  @override
  State<RaiseAnIssuePage> createState() => _RaiseAnIssuePageState();
}

class _RaiseAnIssuePageState extends State<RaiseAnIssuePage> {
  String category = "Payment related";
  TextEditingController desc = TextEditingController();
  bool loading = false;

  submitIssue() async {
    if (desc.text.isEmpty) {
      showToast("Please enter a description");
      return false;
    }

    try {
      setState(() {
        loading = true;
      });

      await ProfileRepo.submitIssue(type: category, message: desc.text);
      showToast("Your new issue has been submitted");
      desc.clear();
      setState(() {
        category = "Payment related";
        loading = false;
      });
    } catch (e) {
      showToast("An error has occurred! Please try again");
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: false,
        title: Text("Raise an Issue".toUpperCase()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            CompleteProfileSelectBox(
              title: "Category",
              list: const [
                "Payment related",
                "Profile related",
                "Call related"
              ],
              onChanged: (e) {
                setState(() {
                  category = e!;
                });
              },
            ),
            const SizedBox(height: 20),
            CompleteProfileInputBox(
              title: "Description*",
              maxLines: 4,
              textEditingController: desc,
            ),
            const Spacer(),
            SizedBox(
              width: context.windowWidth,
              height: 55,
              child: ElevatedButton(
                onPressed: loading
                    ? null
                    : () {
                        submitIssue();
                      },
                child: Text(loading ? "Submitting issue" : "Report"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
