import 'package:flutter/material.dart';
import 'package:movies_2/screens/movie_details.dart';

import '../API_model/api_widget_response.dart';
import '../api_manager.dart';
import '../firebase_model/firebase_functions.dart';
import '../firebase_model/movie_model.dart';
import '../utils/constant.dart';

class CategoryMovie extends StatefulWidget {
  static const String routeNamed = "CategoryMovie";
  final int categoryID;

  const CategoryMovie({
    super.key,
    required this.categoryID,
  });

  @override
  State<CategoryMovie> createState() => _CategoryMovieState();
}

class _CategoryMovieState extends State<CategoryMovie> {
  late Future<ApiWidgetResponse> category; // مستقبل الفئة
  ApiWidgetResponse? categoryResult;

  @override
  void initState() {
    super.initState();
    category = ApiManager().getCategoryListMovie(widget.categoryID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        title: const Text(
          "Movie Category", // استخدام null-aware operator
          style: TextStyle(fontSize: 25, color: Colors.amber),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.only(left: 15),
              child: const Text(
                "Kemo",
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            FutureBuilder<ApiWidgetResponse>(
              future: category,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.amber,
                    ),
                  );
                } else if (snapshot.hasData) {
                  categoryResult = snapshot.data;

                  if (categoryResult?.results == null ||
                      categoryResult!.results!.isEmpty) {
                    return const Center(child: Text("No Movies found"));
                  }

                  return Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.6,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 25,
                      ),
                      padding: const EdgeInsets.all(10),
                      itemCount: categoryResult?.results?.length ?? 0,
                      itemBuilder: (context, index) {
                        var movie = categoryResult?.results?[index];

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
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: SizedBox(
                                      height: 225,
                                      width: 185,
                                      child: movie?.backdropPath == null
                                          ? Image.asset(
                                              "assets/image/movies.png")
                                          : Image.network(
                                              filterQuality: FilterQuality.high,
                                              fit: BoxFit.cover,
                                              "${Constant.imagePath}${movie?.posterPath}",
                                            ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            43, 45, 48, 0.7),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    width: 40,
                                    height: 40,
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
                              const SizedBox(height: 10),
                              Text(
                                movie?.originalTitle ?? 'Unknown',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.amber),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.amber,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
