import 'package:flutter/material.dart';

import '../api_manager.dart';
import '../model/category_ditails.dart';
import '../screens/movie_details.dart';
import '../utils/constant.dart';

class CategorymovieSlider extends StatefulWidget {
  final int categoryID;

  const CategorymovieSlider({
    super.key,
    required this.categoryID,
  });

  @override
  State<CategorymovieSlider> createState() => _CategorymovieSliderState();
}

class _CategorymovieSliderState extends State<CategorymovieSlider> {
  CategoryDitailsResponse? movieList;

  late Future<CategoryDitailsResponse> movies;

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  fetchInitialData() {
    movies = ApiManager().getCategoryListMovie(
        widget.categoryID); // هنا يجب أن تتأكد أن الدالة تعيد 'PopularResponse'
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CategoryDitailsResponse>(
      future: movies,
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
          movieList = snapshot.data;

          // التحقق من وجود بيانات
          if (movieList?.results == null || movieList!.results!.isEmpty) {
            return Center(child: Text("No Movies found"));
          }

          // عرض البيانات باستخدام ListView.builder
          return Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemCount: movieList!.results!.length, ////////////////
              itemBuilder: (context, index) {
                var movie = movieList?.results?[index]; ///////////////
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
                                movieID: movie?.id ?? 0, // Ensure valid ID
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
                                  child: movieList
                                              ?.results?[index].backdropPath ==
                                          null
                                      ? Image.asset("assets/image/movies.png")
                                      : Image.network(
                                          filterQuality: FilterQuality.high,
                                          fit: BoxFit.cover,
                                          "${Constant.imagePath}${movieList?.results?[index].posterPath}",
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            SizedBox(
                              width: 200,
                              child: Text(
                                "${movieList?.results?[index].originalTitle ?? 'Unknown'}",
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
    );
  }
}
