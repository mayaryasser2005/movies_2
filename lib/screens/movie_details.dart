import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../API_model/api_widget_response.dart';
import '../API_model/movie_details.dart';
import '../api_manager.dart';
import '../firebase_model/firebase_functions.dart';
import '../firebase_model/movie_model.dart';
import '../utils/constant.dart';
import '../widget/similar_slider.dart';

class MovieDetails extends StatefulWidget {
  final int movieID;

  // final int sameMovieID;
  const MovieDetails({
    super.key,
    required this.movieID,
  });

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  ApiManager apiManager = ApiManager();
  late Future<MovieDitalesResponse> movieDetails; // Correct future type
  late Future<ApiWidgetResponse> sameMovies;
  late MovieDitalesResponse results;
  late Future<ApiWidgetResponse> newReleases;
  @override
  void initState() {
    super.initState();
    fetchInitialData();
    newReleases = ApiManager().getRecent();
  }

  fetchInitialData() async {
    movieDetails = apiManager.getMovieDetails(widget.movieID);
    results = await movieDetails;

    // if (results.belongsToCollection != null) {
    //
    // } else {
    //   sameMovies = Future.value(SimilarMovieResponse(
    //       results: []));
    // }

    sameMovies =
        apiManager.getSimilarMovies(results.belongsToCollection!.id as num);
    setState(() {});
  }

  // fetchInitialData() {
  //
  //   // for(int i = 0;i < results!.belongsToCollection.;i++){
  //     sameMovies = apiManager.getSimilarMovies(results?.belongsToCollection!.id as num);
  //   // }
  //
  //   movieDetails = apiManager.getMovieDetails(widget.movieID);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                FutureBuilder<MovieDitalesResponse>(
                  future: movieDetails,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.amber,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text('Error loading movie details'),
                      );
                    } else if (snapshot.hasData) {
                      var movie = snapshot.data!;

                      // Ensure that genres are not null
                      String genreText =
                          movie.genres?.map((genre) => genre.name).join(", ") ??
                              'Unknown';

                      // Format release date if available
                      String releaseDate = movie.releaseDate != null
                          ? movie.releaseDate!
                          : 'Unknown';

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: SizedBox(
                                  height: 300,
                                  width: 425,
                                  child: movie.backdropPath == null
                                      ? Image.asset(
                                          'assets/image/movies.png',
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          "${Constant.imagePath}${movie.backdropPath}",
                                          filterQuality: FilterQuality.high,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 35, left: 10),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
                                    size: 35,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            margin: const EdgeInsets.only(left: 5),
                            child: Text(
                              movie.originalTitle ?? 'Unknown',
                              maxLines: 2,
                              style: const TextStyle(
                                  fontSize: 25,
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: Text(
                              releaseDate,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(35),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        height: 230,
                                        width: 150,
                                        child: movie.posterPath == null
                                            ? Image.asset(
                                                "assets/image/movies.png")
                                            : Image.network(
                                                "${Constant.imagePath}${movie.posterPath}",
                                                filterQuality:
                                                    FilterQuality.high,
                                                fit: BoxFit.cover,
                                                width: 100,
                                                height: 175,
                                              ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              43, 45, 48, 0.7),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      width: 38,
                                      height: 38,
                                      child: IconButton(
                                        onPressed: () {
                                          MovieModel movies = MovieModel(
                                            title: "${movie.originalTitle}",
                                            description: "${movie.overview}",
                                            date: "${movie.releaseDate}",
                                            image: "${movie.posterPath}",
                                            id: movie.id as int,
                                          );
                                          FirebaseFunctions.addMovie(movies);
                                          movies.isDone = true;
                                          FirebaseFunctions.updateMovie(movies);
                                        },
                                        icon: const Icon(
                                          Icons.add,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 225,
                                    child: Text(
                                      genreText,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.amber,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  SizedBox(
                                    width: 225,
                                    child: Text(
                                      movie.overview ?? 'No overview available',
                                      maxLines: 6,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("More like this",
                              style: GoogleFonts.aBeeZee(
                                  fontSize: 25, color: Colors.amber)),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    } else {
                      return const Center(
                        child: Text('No movie data available'),
                      );
                    }
                  },
                ),
              ],
            ),
            FutureBuilder<ApiWidgetResponse>(
              future: sameMovies,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else if (snapshot.hasData) {
                  // print("snapshot.data.results: ${snapshot.data?}");

                  return SimilarSlider(similarMovieResponse: snapshot.data!);
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
    );
  }
}
