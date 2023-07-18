import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pmwani/my_wifi_list_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    directToHome();
  }

  directToHome() async {
    // darkBlueCustomBar();
    Timer(
        const Duration(milliseconds: 700),
            () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
              return const MyHome();
            })));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color(0xFF0972c9),
          body: Align(
            child:
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Align(
                heightFactor: 0.5,
                child: Image.asset(
                  'assets/images/pm_wani_logo.png',
                  fit: BoxFit.fitWidth,
                  width: MediaQuery.of(context).size.width * .5,
                ),
              ),
            ]),
          )),
    );
  }
}