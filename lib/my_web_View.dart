import 'package:flutter/material.dart';
import 'package:pmwani/constants.dart';
import 'dart:math' show max;
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatefulWidget {
  const MyWebView({Key? key}) : super(key: key);

  @override
  MyWebViewState createState() => MyWebViewState();
}

class MyWebViewState extends State<MyWebView> {
  double contentHeight = 0;
  bool loaded = false;


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: _buildWebView(context, size),
      ),
    );
  }

  Widget _buildWebView(BuildContext context, size) {
    return SizedBox(
      // height: size.height,
      child: WebView(
        // initialUrl: "https://${AppConstants.urlHost}${AppConstants.urlPath}",
        initialUrl: AppConstants.url,
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: {
          JavascriptChannel(
            name: 'extents',
            onMessageReceived: (JavascriptMessage message) {
              setState(() {
                contentHeight = double.parse(message.message);
              });
            },
          )
        },
        onPageFinished: (String url) {
          // setState(() {
          //   loaded = true;
          // });
        },
        onWebViewCreated: (WebViewController ctrl) {
        },
      ),
    );
  }
}