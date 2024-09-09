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
      body: SingleChildScrollView(
        child: Column(
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
                                              filterQuality: FilterQuality.high,
                                              fit: BoxFit.cover,
                                              width: 100,
                                              height: 175,
                                            ),
                                    ),
                                  ),
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
      ),
    );
  }
}
