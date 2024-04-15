import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({Key? key}) : super(key: key);

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  late final WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: 'about:blank',
          zoomEnabled: false,
          gestureNavigationEnabled: true,
          allowsInlineMediaPlayback: true,
          initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
            _loadHtmlFromAssets('assets/web/privacy.html');
          },
          onWebResourceError: (WebResourceError error) async {
            _loadHtmlFromAssets('assets/web/404.html');
          },
        ),
      ),
    );
  }

  _loadHtmlFromAssets(String filename) async {
    String fileText = await rootBundle.loadString(filename);
    _controller.loadUrl(Uri.dataFromString(fileText, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString());
  }
}
