import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myinsta/pages/signIn_page.dart';

import '../services/auth_service.dart';
import 'home_page.dart';

class SplashPage extends StatefulWidget {
  static const String id = "splash_page";

  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initTimer();
  }

  _initTimer() {
    Timer(const Duration(seconds: 2), () {
      callNextPage();
    });
  }

  callNextPage() {
    if (AuthService.isLoggedIn()) {
      Navigator.pushReplacementNamed(context, HomePage.id);
    } else {
      Navigator.pushReplacementNamed(context, SignInPage.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(193, 53, 132, 1),
                  Color.fromRGBO(131, 58, 180, 1),
                ])),
        child: const Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  "Instagram",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 45,
                      fontFamily: "Billabong"),
                ),
              ),
            ),
            Text(
              "All rights reserved",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}