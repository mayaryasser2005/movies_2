import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_2/widget/similar_slider.dart';

import '../API_model/NewReleases.dart';
import '../API_model/movie_details.dart';
import '../API_model/similar_movie.dart';
import '../api_manager.dart';
import '../utils/constant.dart';

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
  late Future<SimilarMovieResponse> sameMovies;
  late SimilarMovieResponse results;
  late Future<NewReleasesResponse> NewReleases;
  @override
  void initState() {
    super.initState();
    fetchInitialData();
    NewReleases = ApiManager().getRecent() as Future<NewReleasesResponse>;
  }

  fetchInitialData() {
    // Assign the correct future for movie details
    //
    sameMovies = apiManager.getSimilarMovies(results.results.id);
    movieDetails = apiManager.getMovieDetails(widget.movieID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  child: FutureBuilder<MovieDitalesResponse>(
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
                        String genreText = movie.genres
                                ?.map((genre) => genre.name)
                                .join(", ") ??
                            'Unknown';

                        // Format release date if available
                        String releaseDate = movie.releaseDate != null
                            ? "${movie.releaseDate!}"
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
                                  margin: EdgeInsets.only(top: 35, left: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(75)),
                                  child: IconButton(
                                    icon: Icon(
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
                              margin: EdgeInsets.only(left: 5),
                              child: Text(
                                movie.originalTitle ?? 'Unknown',
                                maxLines: 2,
                                style: const TextStyle(fontSize: 25),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                releaseDate,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Row(
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          height: 230,
                                          width: 125,
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
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        width: 33,
                                        height: 33,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.add,
                                            size: 20,
                                            color: Colors.black,
                                          ),
                                          onPressed: () {},
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
                                      width: 200,
                                      child: Text(
                                        genreText,
                                        style: const TextStyle(
                                            fontSize: 15, color: Colors.grey),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: 250,
                                      child: Text(
                                        movie.overview ??
                                            'No overview available',
                                        maxLines: 5,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text("More like this",
                                style: GoogleFonts.aBeeZee(fontSize: 25)),
                            SizedBox(
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
                ),
              ],
            ),

            FutureBuilder<SimilarMovieResponse>(
              future: sameMovies,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else if (snapshot.hasData) {
                  // التأكد من الوصول إلى 'results' في 'PopularResponse'
                  return SimilarSlider(
                      results: snapshot.data as SimilarMovieResponse);
                } else {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Colors.amber,
                  ));
                }
              },
            ),
            // FutureBuilder<SimilarMovieResponse>(
            //   future: sameMovies,
            //   builder: (context, snapshot) {
            //     if (snapshot.hasError) {
            //       return Center(child: Text(snapshot.error.toString()));
            //     } else if (snapshot.hasData) {
            //       // التأكد من الوصول إلى 'results' في 'PopularResponse'
            //       return SizedBox(
            //         height: 200,
            //         width: double.infinity,
            //         child: ListView.builder(
            //           scrollDirection: Axis.horizontal,
            //           physics: BouncingScrollPhysics(),
            //           itemCount: 10,
            //           // Adjust according to your data source
            //           itemBuilder: (context, index) {
            //             var movie = results.results?[index];
            //             return InkWell(
            //               onTap: () {
            //                 Navigator.push(
            //                   context,
            //                   MaterialPageRoute(
            //                     builder: (context) => MovieDetails(
            //                       movieID: movie?.id ?? 0, // Ensure valid ID
            //                     ),
            //                   ),
            //                 );
            //               },
            //               child:  Stack(
            //                 children: [
            //                   ClipRRect(
            //                       borderRadius: BorderRadius.circular(8),
            //                       child: SizedBox(
            //                           height: 200,
            //                           width: 150,
            //                           child: Image.network(
            //                               filterQuality: FilterQuality.high,
            //                               fit: BoxFit.cover,
            //                               "${Constant.imagePath}${results.results?[index].posterPath}"))),
            //                   Container(
            //                     decoration: BoxDecoration(
            //                         color: Colors.grey,
            //                         borderRadius: BorderRadius.circular(5)),
            //                     width: 33,
            //                     height: 33,
            //                     child: IconButton(
            //                       icon: Icon(
            //                         Icons.add,
            //                         size: 20,
            //                         color: Colors.black,
            //                       ),
            //                       onPressed: () {},
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             );
            //           },
            //         ),
            //       );
            //     } else {
            //       return const Center(
            //           child: CircularProgressIndicator(
            //             color: Colors.amber,
            //           ));
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
