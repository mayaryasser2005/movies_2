import 'package:flutter/material.dart';
import 'package:movies_2/model/category.dart';

import '../api_manager.dart';

class CategoryItem extends StatefulWidget {
  CategoryItem({super.key});

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  late Future<CategoriesResponse> category; // مستقبل الفئة
  CategoriesResponse? listCategory; // جعل listCategory قابلاً لأن يكون null
  Genres? genres;

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
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          // تعيين البيانات إلى listCategory عند استرجاع البيانات
          listCategory = snapshot.data;

          // التحقق من وجود بيانات
          if (listCategory?.genres == null || listCategory!.genres!.isEmpty) {
            return Center(child: Text("No categories found"));
          }

          // عرض البيانات باستخدام ListView.builder
          return ListView.builder(
            itemCount: listCategory!.genres!.length,
            itemBuilder: (context, index) {
              var genre = listCategory!.genres![index];
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          child: Image.asset(
                            "assets/image/${genre.id}.jpg", // استخدام genre.id
                            height: 100,
                            width: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 20),
                        Text(
                          genre.name ?? "Unknown Category", // عرض اسم الفئة
                          style: TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
