import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fore_astro_2/core/data/repository/communicationRepo.dart';
import 'package:fore_astro_2/core/helper/helper.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';

class SendRemedyScreen extends StatefulWidget {
  const SendRemedyScreen({super.key});

  @override
  State<SendRemedyScreen> createState() => _SendRemedyScreenState();
}

class _SendRemedyScreenState extends State<SendRemedyScreen> {
  TextEditingController _controller = TextEditingController();
  bool loading = false;
  final String remedyKey = 'remedy_text';

  @override
  void initState() {
    super.initState();
    _loadRemedy(); // Load saved remedy when the screen initializes
  }

  Future<void> _loadRemedy() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedRemedy = prefs.getString(remedyKey);
    if (savedRemedy != null) {
      setState(() {
        _controller.text = savedRemedy; // Set saved remedy in the TextField
      });
    }
  }

  Future<void> _saveRemedy(String remedy) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        remedyKey, remedy); // Save remedy in SharedPreferences
  }

  Future<void> onSend() async {
    if (_controller.text.trim().isEmpty) {
      showToast("Write Your Remedy");
      return;
    }
    try {
      setState(() {
        loading = true;
      });
      // Send Task Here
      await CommunicationRepo.astroRamedyCreate(_controller.text);
      await _saveRemedy(_controller.text); // Save remedy after sending
      setState(() {
        loading = false;
      });
      showToast("Remedy Update Successfully");
    } catch (e) {
      setState(() {
        loading = false;
      });
      showToast("Oops, Failed To send Remedy. Please try Again");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Today Remedy".toUpperCase()),
        actions: [
          IconButton(
            onPressed: loading ? null : onSend,
            icon: Icon(
              Icons.send,
              color: loading ? Colors.grey : AppColor.primary,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                maxLines: 8,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none,
                  hintText: "Write Your Remedy",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
