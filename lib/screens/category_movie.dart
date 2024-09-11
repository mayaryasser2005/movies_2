import 'package:flutter/material.dart';
import 'package:movies_2/screens/movie_details.dart';

import '../API_model/api_widget_response.dart';
import '../API_model/category.dart';
import '../api_manager.dart';
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
  Genres? genres;
  late Future<ApiWidgetResponse> category; // مستقبل الفئة
  ApiWidgetResponse? categoryResult;

  @override
  void initState() {
    super.initState();
    category = ApiManager().getCategoryListMovie(widget.categoryID)
        as Future<ApiWidgetResponse>; // استدعاء API لجلب الفئات
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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

                  // التحقق من وجود بيانات
                  if (categoryResult?.results == null ||
                      categoryResult!.results!.isEmpty) {
                    return const Center(child: Text("No Movies found"));
                  }

                  // عرض البيانات باستخدام GridView.builder
                  return Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        // عدد الأعمدة
                        childAspectRatio: 0.6,
                        // نسبة العرض إلى الارتفاع للعناصر
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 25,
                      ),
                      padding: const EdgeInsets.all(10),
                      itemCount: categoryResult?.results?.length ?? 0,
                      // التحقق من null
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
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: SizedBox(
                                  height: 225,
                                  width: 185,
                                  child: movie?.backdropPath == null
                                      ? Image.asset("assets/image/movies.png")
                                      : Image.network(
                                          filterQuality: FilterQuality.high,
                                          fit: BoxFit.cover,
                                          "${Constant.imagePath}${movie?.posterPath}",
                                        ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                movie?.originalTitle ?? 'Unknown',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 20,
                                    // fontWeight: FontWeight.bold,
                                    color: Colors.amber),
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
