import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_2/API_model/api_widget_response.dart';
import 'package:movies_2/api_manager.dart';
import 'package:movies_2/firebase_model/movie_model.dart';
import 'package:movies_2/screens/tabs/search.dart';

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
  late Future<ApiWidgetResponse> popular;
  late Future<ApiWidgetResponse> NewReleases;
  late Future<ApiWidgetResponse> Recomended;
  @override
  void initState() {
    super.initState();
    popular = ApiManager().getPopular() as Future<
        ApiWidgetResponse>; // هنا يجب أن تتأكد أن الدالة تعيد 'PopularResponse'
    NewReleases = ApiManager().getRecent() as Future<ApiWidgetResponse>;
    Recomended = ApiManager().getRecomended() as Future<ApiWidgetResponse>;
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
                Navigator.pushNamed(context, Search.routeNamed);
              },
              highlightColor: Colors.amber,
              icon: const Icon(Icons.search, color: Colors.amber)),
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
              FutureBuilder<ApiWidgetResponse>(
                future: popular,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else if (snapshot.hasData) {
                    // التأكد من الوصول إلى 'results' في 'PopularResponse'
                    return PopularSlider(
                        results: snapshot.data as ApiWidgetResponse);
                  } else {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.amber,
                    ));
                  }
                },
              ),
              const SizedBox(height: 20),
              Text(
                "New Releases",
                style: GoogleFonts.aBeeZee(fontSize: 25, color: Colors.amber),
              ),
              const SizedBox(height: 20),
              FutureBuilder<ApiWidgetResponse>(
                future: NewReleases,
                builder: (context, snapshot) {
                  MovieModel? movieModel;
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else if (snapshot.hasData) {
                    // التأكد من الوصول إلى 'results' في 'PopularResponse'

                    return NewReleasesSlider(
                      results: snapshot.data as ApiWidgetResponse,
                    );
                  } else {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.amber,
                    ));
                  }
                },
              ),
              Text(
                "Recommended",
                style: GoogleFonts.aBeeZee(fontSize: 25, color: Colors.amber),
              ),
              const SizedBox(height: 20),
              FutureBuilder<ApiWidgetResponse>(
                future: Recomended,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else if (snapshot.hasData) {
                    // التأكد من الوصول إلى 'results' في 'PopularResponse'
                    return RecomendedSlider(
                        results: snapshot.data as ApiWidgetResponse);
                  } else {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.amber,
                    ));
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