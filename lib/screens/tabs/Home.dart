import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_2/screens/tabs/search.dart';

import '../../API_model/NewReleases.dart';
import '../../API_model/Recomended.dart';
import '../../API_model/popular.dart';
import '../../api_manager.dart';
import '../../firebase_model/movie_model.dart';
import '../../widget/New_Releases.dart';
import '../../widget/Recomended.dart';
import '../../widget/popular_slider.dart';

class HomeTab extends StatefulWidget {
  static const String routeNamed = "home";
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late Future<PopularResponse> popular;
  late Future<NewReleasesResponse> NewReleases;
  late Future<RecomendedResponse> Recomended;

  Color _iconColor = Colors.amber; // إضافة متغير لتخزين اللون الحالي للأيقونة

  @override
  void initState() {
    super.initState();
    popular = ApiManager().getPopular() as Future<PopularResponse>;
    NewReleases = ApiManager().getRecent() as Future<NewReleasesResponse>;
    Recomended = ApiManager().getRecomended() as Future<RecomendedResponse>;
  }

  @override
  Widget build(BuildContext context) {
    MovieModel movieModel;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Movies",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // تغيير لون الأيقونة عند الضغط
              setState(() {
                _iconColor =
                    _iconColor == Colors.green ? Colors.red : Colors.amber;
              });
              Navigator.pushNamed(context, Search.routeNamed);
            },
            icon:
                Icon(Icons.search, color: _iconColor), // استخدام اللون المتغير
          ),
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              FutureBuilder<PopularResponse>(
                future: popular,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else if (snapshot.hasData) {
                    return PopularSlider(
                        results: snapshot.data as PopularResponse);
                  } else {
                    return const Center(
                        child: CircularProgressIndicator(color: Colors.amber));
                  }
                },
              ),
              const SizedBox(height: 20),
              Text(
                "New Releases",
                style: GoogleFonts.aBeeZee(fontSize: 25, color: Colors.amber),
              ),
              const SizedBox(height: 20),
              FutureBuilder<NewReleasesResponse>(
                future: NewReleases,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else if (snapshot.hasData) {
                    return NewReleasesSlider(
                        results: snapshot.data as NewReleasesResponse);
                  } else {
                    return const Center(
                        child: CircularProgressIndicator(color: Colors.amber));
                  }
                },
              ),
              Text(
                "Recommended",
                style: GoogleFonts.aBeeZee(fontSize: 25, color: Colors.amber),
              ),
              const SizedBox(height: 20),
              FutureBuilder<RecomendedResponse>(
                future: Recomended,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else if (snapshot.hasData) {
                    return RecomendedSlider(
                        results: snapshot.data as RecomendedResponse);
                  } else {
                    return const Center(
                        child: CircularProgressIndicator(color: Colors.amber));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
