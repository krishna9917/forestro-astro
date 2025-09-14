import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fore_astro_2/core/data/model/ExamQModel.dart';
import 'package:fore_astro_2/core/data/repository/examRepo.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:fore_astro_2/core/helper/helper.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:fore_astro_2/providers/UserProfileProvider.dart';
import 'package:fore_astro_2/screens/auth/WattingScreen.dart';
import 'package:fore_astro_2/screens/main/HomeTabScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AstroExamScreen extends StatefulWidget {
  const AstroExamScreen({super.key});

  @override
  State<AstroExamScreen> createState() => _AstroExamScreenState();
}

class _AstroExamScreenState extends State<AstroExamScreen> {
  bool loading = true;
  bool submitLoading = false;

  List<ExamQModel>? examsQuestions;
  PageController _pageController = PageController();
  int _currentPage = 0;
  TextEditingController _answerEditingController = TextEditingController();
  loadQuestions() async {
    try {
      Response response = await ExamRepo.loadExam();
      setState(() {
        loading = false;
        if (response.data['data'].length != 0) {
          examsQuestions = List.generate(response.data['data'].length,
              (index) => ExamQModel.fromJson(response.data['data'][index]));
        }
      });
    } catch (e) {
      setState(() {
        loading = false;
        examsQuestions = null;
      });
    }
  }

  @override
  void initState() {
    loadQuestions();
    super.initState();
  }

  submitAnswerAnsNext() async {
    if (_answerEditingController.text.isEmpty) {
      showToast("Please Write your Answer");
      return false;
    }
    try {
      setState(() {
        submitLoading = true;
      });
      await ExamRepo.submitAnswer(
        question: examsQuestions![_currentPage].question!,
        answer: _answerEditingController.text,
      );
      if (_currentPage != examsQuestions!.length - 1) {
        _answerEditingController.clear();
        _pageController.nextPage(
            duration: const Duration(
              milliseconds: 100,
            ),
            curve: Curves.linear);
      } else {
        navigateme.popUntil((route) => route.isFirst);
        navigateme.pushReplacement(routeMe( WettingScreen(status: "pending",)));
      }
      setState(() {
        submitLoading = false;
      });
    } catch (e) {
      setState(() {
        submitLoading = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Onboarding Questions".toUpperCase(),
        ),
        centerTitle: true,
      ),
      body: Builder(builder: (context) {
        if (loading) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColor.primary,
              strokeCap: StrokeCap.round,
            ),
          );
        }
        if (examsQuestions == null) {
          return Center(
            child: SizedBox(
              height: 400,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     Text(
                      'No Questions Found',
                      style: GoogleFonts.inter(
                        color: Color(0xFF201F1F),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                     Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Our team will review your profile and notify you once it has been approved. Thank you for your patience.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: Color(0xFF515151),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          loading = true;
                          loadQuestions();
                        });
                      },
                      child: loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                                strokeCap: StrokeCap.round,
                              ),
                            )
                          : const Text("Reload"),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return PageView.builder(
          itemCount: examsQuestions!.length,
          controller: _pageController,
          onPageChanged: (e) {
            setState(() {
              _currentPage = e;
            });
          },
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            ExamQModel qus = examsQuestions![index];
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Q. ${qus.question}",
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      maxLines: qus.type == "input" ? 1 : 6,
                      controller: _answerEditingController,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: InputBorder.none,
                        errorBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: "Write Your Answer",
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: (!loading && examsQuestions != null)
          ? FloatingActionButton.extended(
              onPressed: submitLoading
                  ? null
                  : () {
                      submitAnswerAnsNext();
                    },
              label: submitLoading
                  ? const SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                        strokeCap: StrokeCap.round,
                      ),
                    )
                  : Text(
                      (_currentPage == examsQuestions!.length - 1
                              ? "Finish"
                              : "Next")
                          .toUpperCase(),
                      style:  GoogleFonts.inter(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
              icon: submitLoading
                  ? null
                  : const Icon(Icons.navigate_next_rounded,
                      color: Colors.white),
            )
          : null,
    );
  }
}
