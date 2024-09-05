import 'package:flutter/cupertino.dart';
import 'package:movies_2/screens/tabs/Home.dart';

import '../screens/home.dart';
import '../utils/app_assets.dart';

class Splash extends StatefulWidget {
  static const String routeNamed = "Splash";

  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, Home.routeNamed);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Image.asset
        (
         AppAssets.Splash
      ),
    );
  }
}
