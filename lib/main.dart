import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myinsta/pages/home_page.dart';
import 'package:myinsta/pages/signIn_page.dart';
import 'package:myinsta/pages/signUp_page.dart';
import 'package:myinsta/pages/splash_page.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "<your_api_key>",
          appId: "1:206722581455:android:defd8b08d9c1013aaa88ba",
          messagingSenderId: "206722581455",
          projectId: "myinsta-4e0de",
          storageBucket: "<your_storage_bucket>"
      ),
    name: "myinsta",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashPage(),
      routes: {
        SplashPage.id:(context) => const SplashPage(),
        SignInPage.id:(context) => const SignInPage(),
        SignUpPage.id:(context) => const SignUpPage(),
        HomePage.id:(context) => const HomePage(),
      },
    );
  }
}
