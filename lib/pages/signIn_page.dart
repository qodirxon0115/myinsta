import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myinsta/pages/signUp_page.dart';

import '../services/auth_service.dart';
import 'home_page.dart';

class SignInPage extends StatefulWidget {
  static const String id = "signIn_page";

  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var isLoading = false;
  var emailController = TextEditingController();
  var passController = TextEditingController();

  _doSignIn() {
    String email = emailController.text.toString().trim();
    String password = passController.text.toString().trim();
    if (email.isEmpty || password.isEmpty) return;

    setState(() {
      isLoading = true;
    });
    AuthService.signInUser(email, password).then((value) => {
      responseSignIn(value!),
    });
  }

  responseSignIn(User firebaseUser) {
    setState(() {
      isLoading = false;
    });
    Navigator.pushReplacementNamed(context, HomePage.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(193, 53, 132, 1),
                    Color.fromRGBO(131, 58, 180, 1),
                  ])),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Instagram",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 45,
                              fontFamily: "Billabong"),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          height: 50,
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: TextField(
                            controller: emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: "Email",
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  color: Colors.white54, fontSize: 17),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          height: 50,
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: TextField(
                            obscureText: true,
                            controller: passController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: "Password",
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  color: Colors.white54, fontSize: 17),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _doSignIn();
                          },
                          child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              height: 50,
                              padding:
                              const EdgeInsets.only(left: 15, right: 15),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: const Center(
                                child: Text(
                                  "Sign In",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, SignUpPage.id);
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
              isLoading
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : const SizedBox.shrink()
            ],
          )),
    );
  }
}