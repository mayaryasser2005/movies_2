import 'package:flutter/material.dart';

import '../API_model/api_widget_response.dart';
import '../API_model/category.dart';
import '../api_manager.dart';
import '../screens/category_movie.dart';

class CategoryItem extends StatefulWidget {
  const CategoryItem({super.key});

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  late Future<CategoriesResponse> category; // مستقبل الفئة
  CategoriesResponse? listCategory; // جعل listCategory قابلاً لأن يكون null
  Genres? genres;
  ApiWidgetResponse? categoryResult;

  @override
  void initState() {
    super.initState();
    category = ApiManager().getCategoryMovie(); // استدعاء API لجلب الفئات
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CategoriesResponse>(
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
          if (listCategory?.genres == null || listCategory!.genres!.isEmpty) {
            return const Center(child: Text("No categories found"));
          }

          // عرض البيانات باستخدام GridView.builder
          return Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                childAspectRatio: 1.2, // Adjust the size of grid items
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
              ),
              padding: const EdgeInsets.all(10),
              itemCount: listCategory!.genres!.length, // عدد العناصر
              itemBuilder: (context, index) {
                var movie = listCategory?.genres?[index]; // Get the movie genre
                var genre = listCategory!.genres![index]; // Get genre data
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryMovie(
                          categoryID: movie?.id ?? 0, // Ensure valid ID
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          "assets/image/${genre.id}.jpg",
                          height: 110,
                          width: 190,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        genre.name ?? "Unknown Category", // عرض اسم الفئة
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.amber,
                        ),
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
          ));
        }
      },
    );
  }
}
