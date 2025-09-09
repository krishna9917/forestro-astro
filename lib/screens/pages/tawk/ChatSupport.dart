import 'package:flutter/material.dart';
import 'package:flutter_tawk/flutter_tawk.dart';
import 'package:fore_astro_2/providers/UserProfileProvider.dart';
import 'package:provider/provider.dart';

class ChatSupport extends StatelessWidget {
  const ChatSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Tawk(
          directChatLink:
              'https://tawk.to/chat/668cfb2ec3fb85929e3d20bb/1i2bbabtl',
          placeholder: Center(
            child: CircularProgressIndicator(),
          ),
          visitor: TawkVisitor(
            name: context.read<UserProfileProvider>().userProfileModel!.name,
            email: context.read<UserProfileProvider>().userProfileModel!.email,
          ),
        ),
      ),
    );
  }
}
