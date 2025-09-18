import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChatSupport extends StatefulWidget {
  const ChatSupport({super.key});

  @override
  State<ChatSupport> createState() => _ChatSupportState();
}

class _ChatSupportState extends State<ChatSupport> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Tawk needs JS
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            debugPrint("Loading: $url");
          },
          onPageFinished: (url) {
            debugPrint("Loaded: $url");
          },
          onWebResourceError: (error) {
            debugPrint("Error: $error");
          },
        ),
      )
      ..loadRequest(
        Uri.parse("https://tawk.to/chat/668cfb2ec3fb85929e3d20bb/1i2bbabtl"),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live Chat")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
