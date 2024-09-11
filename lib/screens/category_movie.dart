import 'package:flutter/material.dart';
import 'package:movies_2/screens/movie_details.dart';

import '../API_model/category.dart';
import '../API_model/category_ditails.dart';
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
  late Future<CategoryDitailsResponse> category; // مستقبل الفئة
  CategoriesResponse? listCategory; // جعل listCategory قابلاً لأن يكون null
  CategoryDitailsResponse? categoryResult;

  @override
  void initState() {
    super.initState();
    category = ApiManager().getCategoryListMovie(widget.categoryID)
        as Future<CategoryDitailsResponse>; // استدعاء API لجلب الفئات
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "MovieCategory", // استخدام null-aware operator
          style: const TextStyle(fontSize: 25),
        ),
      ),
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 50,
          ),
          const SizedBox(
            height: 20,
          ),
          FutureBuilder<CategoryDitailsResponse>(
            future: category,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.amber,
                ));
              } else if (snapshot.hasData) {
                // تعيين البيانات إلى listCategory عند استرجاع البيانات
                categoryResult = snapshot.data;

                //التحقق من وجود بيانات
                if (categoryResult?.results == null ||
                    categoryResult!.results!.isEmpty) {
                  return const Center(child: Text("No Movies found"));
                }

                // عرض البيانات باستخدام ListView.builder
                return Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: categoryResult?.results?.length ?? 0,
                    // التحقق من null
                    itemBuilder: (context, index) {
                      var movie =
                          categoryResult?.results?[index]; // التحقق من null
                      // if (movie == null) {
                      //   return const SizedBox(); // التعامل مع حالة null
                      // }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetails(
                                      movieID:
                                          movie?.id ?? 0, // Ensure valid ID
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: SizedBox(
                                      height: 100,
                                      width: 175,
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
                                  SizedBox(width: 10),
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      movie?.originalTitle ?? 'Unknown',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              } else {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.amber,
                ));
              }
            },
          )
        ]),
      ),
    );
  }
}