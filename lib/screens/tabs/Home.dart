import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_2/api_manager.dart';
import 'package:movies_2/screens/tabs/search.dart';

import '../../model/NewReleases.dart';
import '../../model/Recomended.dart';
import '../../model/popular.dart';
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
  @override
  void initState() {
    super.initState();
    popular = ApiManager().getPopular() as Future<
        PopularResponse>; // هنا يجب أن تتأكد أن الدالة تعيد 'PopularResponse'
    NewReleases = ApiManager().getRecent() as Future<NewReleasesResponse>;
    Recomended = ApiManager().getRecomended() as Future<RecomendedResponse>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Movies",
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, Search.routeNamed);
              },
              icon: Icon(Icons.search))
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                    // التأكد من الوصول إلى 'results' في 'PopularResponse'
                    return PopularSlider(
                        results: snapshot.data as PopularResponse);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              const SizedBox(height: 32),
              Text(
                "New Releases",
                style: GoogleFonts.aBeeZee(fontSize: 25),
              ),
              const SizedBox(height: 32),
              FutureBuilder<NewReleasesResponse>(
                future: NewReleases,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else if (snapshot.hasData) {
                    // التأكد من الوصول إلى 'results' في 'PopularResponse'
                    return NewReleasesSlider(
                        results: snapshot.data as NewReleasesResponse);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              Text(
                "Recommended",
                style: GoogleFonts.aBeeZee(fontSize: 25),
              ),
              const SizedBox(height: 32),
              FutureBuilder<RecomendedResponse>(
                future: Recomended,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else if (snapshot.hasData) {
                    // التأكد من الوصول إلى 'results' في 'PopularResponse'
                    return RecomendedSlider(
                        results: snapshot.data as RecomendedResponse);
                  } else {
                    return const Center(child: CircularProgressIndicator());
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
