import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pmwani/home_page.dart';
import 'package:pmwani/my_url_launcher.dart';
import 'package:pmwani/my_web_View.dart';
import 'package:pmwani/my_wifi_list_page.dart';
import 'package:wifi_scan/wifi_scan.dart';

void main() {
  runApp(const MyApp());
}

/// Example app for wifi_scan plugin.
class MyApp extends StatefulWidget {
  /// Default constructor for [MyApp] widget.
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "PM Wani",
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context).copyWith(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey)),
      home:  const MyHomePage(title: '',),
    );
  }
}


