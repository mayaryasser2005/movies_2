import 'package:flutter/material.dart';
import 'package:movies_2/screens/movie_details.dart';

import '../api_manager.dart';
import '../model/category.dart';
import '../model/category_ditails.dart';
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

  // CategoryDitailsResponse? categoryDitailsID;
  late Future<CategoriesResponse> category; // مستقبل الفئة
  CategoriesResponse? listCategory; // جعل listCategory قابلاً لأن يكون null
  CategoryDitailsResponse? categoryResult;

  @override
  void initState() {
    super.initState();
    category = ApiManager().getCategoryMovie(); // استدعاء API لجلب الفئات
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 50,
          ),
          Text(
            "${genres!.name}",
            style: const TextStyle(fontSize: 25),
          ),
          const SizedBox(
            height: 20,
          ),
          FutureBuilder<CategoriesResponse>(
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
                listCategory = snapshot.data;

                // التحقق من وجود بيانات
                if (listCategory?.genres == null ||
                    listCategory!.genres!.isEmpty) {
                  return const Center(child: Text("No categories found"));
                }

                // عرض البيانات باستخدام ListView.builder
                return Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: categoryResult!.results!.length,
                    ////////////////
                    itemBuilder: (context, index) {
                      var movie =
                          categoryResult!.results![index]; ///////////////
                      // var genre = listCategory!.genres![index];/////////////////////
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
                                      movieID: movie.id ?? 0, // Ensure valid ID
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        height: 100,
                                        width: 175,
                                        child: movie.backdropPath == null
                                            ? Image.asset(
                                                "assets/image/movies.png")
                                            : Image.network(
                                                filterQuality:
                                                    FilterQuality.high,
                                                fit: BoxFit.cover,
                                                "${Constant.imagePath}${movie.posterPath}",
                                              ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      movie.originalTitle ?? 'Unknown',
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
