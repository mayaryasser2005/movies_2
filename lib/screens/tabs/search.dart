import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies_2/screens/movie_details.dart';

import '../../API_model/api_widget_response.dart';
import '../../api_manager.dart';
import '../../firebase_model/firebase_functions.dart';
import '../../firebase_model/movie_model.dart';
import '../../utils/constant.dart';

class Search extends StatefulWidget {
  static const String routeNamed = "Search";

  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  ApiManager apiManager = ApiManager();
  ApiWidgetResponse? search; // Ensure correct spelling (SearchResponse)

  void searchMovies(String query) {
    apiManager.getSearchMovies(query).then((results) {
      setState(() {
        search = results; // Update search results
      });
    }).catchError((error) {
      // Handle errors, if any
      // print('Error: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 25.0, left: 10, right: 10, bottom: 10),
              child: CupertinoSearchTextField(
                borderRadius: BorderRadius.circular(20),
                padding: const EdgeInsets.all(15),
                controller: searchController,
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.amber,
                  size: 25,
                ),
                suffixIcon: const Icon(
                  Icons.cancel,
                  color: Colors.amber,
                  size: 22,
                ),
                style: const TextStyle(color: Colors.white),
                backgroundColor: Colors.grey.withOpacity(0.3),
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      search = null; // Clear search results if input is empty
                    });
                  } else {
                    searchMovies(value); // Perform search on text change
                  }
                },
              ),
            ),
            Expanded(
              child: search == null
                  ? const Center(child: Text('No results'))
                  : ListView.builder(
                      itemCount: search?.results?.length ?? 0,
                      // Check if results are null
                      itemBuilder: (context, index) {
                        var movie = search?.results?[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetails(
                                  movieID: movie?.id ?? 0, // Ensure valid ID
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        height: 250,
                                        width: 175,
                                        child: movie?.backdropPath == null
                                            ? Image.asset(
                                                "assets/image/movies.png")
                                            : Image.network(
                                                filterQuality:
                                                    FilterQuality.high,
                                                fit: BoxFit.cover,
                                                "${Constant.imagePath}${movie?.posterPath}",
                                              ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            43, 45, 48, 0.7),
                                        borderRadius: BorderRadius.circular(5)),
                                    width: 38,
                                    height: 38,
                                    child: IconButton(
                                      onPressed: () {
                                        MovieModel movies = MovieModel(
                                          title: "${movie?.originalTitle}",
                                          description: "${movie?.overview}",
                                          date: "${movie?.releaseDate}",
                                          image: "${movie?.posterPath}",
                                          id: movie?.id as int,
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
                                ],
                              ),
                              const SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      movie?.originalTitle ?? 'Unknown',
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 23, color: Colors.amber),
                                    ),
                                  ),
                                  Text(
                                    "${movie?.releaseDate}",
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
