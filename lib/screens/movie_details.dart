import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../api_manager.dart';
import '../model/movie_details.dart';
import '../utils/constant.dart';

class MovieDetails extends StatefulWidget {
  final int movieID;

  const MovieDetails({super.key, required this.movieID});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  ApiManager apiManager = ApiManager();
  late Future<MovieDitalesResponse> movieDetails; // Correct future type

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  fetchInitialData() {
    // Assign the correct future for movie details
    movieDetails = apiManager.getMovieDetails(widget.movieID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                // decoration: const BoxDecoration(
                //   color: Colors.black12, // Default background color
                // ),
                child: FutureBuilder<MovieDitalesResponse>(
                  future: movieDetails,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
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
                          ? "${movie.releaseDate!}"
                          : 'Unknown';

                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: SizedBox(
                                    height: 300,
                                    width: 400,
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
                                IconButton(
                                  icon: Icon(Icons.arrow_back,
                                      color: Colors.black),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie.originalTitle ?? 'Unknown',
                                    maxLines: 2,
                                    style: const TextStyle(fontSize: 25),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    releaseDate,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Row(
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
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 200,
                                            child: Text(
                                              genreText,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          SizedBox(
                                            width: 220,
                                            child: Text(
                                              movie.overview ??
                                                  'No overview available',
                                              maxLines: 5,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Text("More like this", style: GoogleFonts.aBeeZee(fontSize: 25)),
                            SizedBox(
                              height: 200,
                              width: double.infinity,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                itemCount: 10,
                                // Adjust according to your data source
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        width: 150,
                                        color: Colors.amber,
                                        // Placeholder color
                                        child: Center(
                                          child: Text(
                                            'Item $index',
                                            // Replace with actual content
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
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
        ],
      ),
    );
  }
}
