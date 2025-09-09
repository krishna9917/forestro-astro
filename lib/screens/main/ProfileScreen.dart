import 'package:flutter/material.dart';
import 'package:fore_astro_2/Components/WalletBox.dart';
import 'package:fore_astro_2/screens/main/Tabs/ProfileTabView.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          WalletBox(),
          SizedBox(width: 15),
        ],
      ),
      body: ProfiletabView(),
    );
  }
}
