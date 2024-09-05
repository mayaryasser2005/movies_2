import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies_2/screens/tabs/Home.dart';
import 'package:movies_2/screens/tabs/browse.dart';
import 'package:movies_2/screens/tabs/listwatch.dart';
import 'package:movies_2/screens/tabs/search.dart';
import 'package:movies_2/utils/app_colors.dart';
class Home extends StatefulWidget {
  static const String routeNamed = "Home";
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int sellectedTabIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [HomeTab(), Search(), Browse(), ListWatch()];
    return Scaffold(
      bottomNavigationBar: Theme(
        data: ThemeData(canvasColor: AppColors.primary),
        child: BottomNavigationBar(
          currentIndex: sellectedTabIndex,
          onTap: (index) {
            sellectedTabIndex = index;
            setState(() {});
          },
          selectedItemColor: AppColors.secondly,
          showUnselectedLabels: true,
          // backgroundColor: AppColors.primary,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
            BottomNavigationBarItem(
                icon: Icon(Icons.movie_creation_rounded), label: "Browse"),
            BottomNavigationBarItem(
                icon: Icon(Icons.movie_creation_rounded), label: "ListWatch"),
          ],
        ),
      ),
      body: tabs[sellectedTabIndex]
    );
  }
}
