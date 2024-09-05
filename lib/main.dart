import 'package:flutter/material.dart';
import 'package:movies_2/screens/home.dart';
import 'package:movies_2/screens/tabs/Home.dart';
import 'package:movies_2/splash/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          useMaterial3: true
      ),
      routes: {
        Splash.routeNamed:(_) => Splash(),
        Home.routeNamed:(_) => Home()
      },
      initialRoute: Splash.routeNamed,
    );
  }
}