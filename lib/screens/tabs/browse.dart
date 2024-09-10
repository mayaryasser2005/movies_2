import 'package:flutter/material.dart';
import 'package:movies_2/model/category.dart';

import '../../api_manager.dart';
import '../../widget/category_item.dart';

class Browse extends StatefulWidget {
  static const String routeNamed = "Browse";

  const Browse({super.key});

  @override
  State<Browse> createState() => _BrowseState();
}

class _BrowseState extends State<Browse> {
  late Future<CategoriesResponse> category;

  @override
  void initState() {
    super.initState();
    category = ApiManager().getCategoryMovie() as Future<CategoriesResponse>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              "Browser Category",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 20,
            ),

            CategoryItem()
            //
            // FutureBuilder<CategoriesResponse>(
            //   future:category, // استخدام future هنا
            //   builder: (context, snapshot) {
            //     if (snapshot.hasError) {
            //       return Center(child: Text(snapshot.error.toString()));
            //     } else if (snapshot.hasData) {
            //       var categoryData = snapshot.data!;
            //       return CategoryItem();
            //     } else {
            //       return const Center(child: CircularProgressIndicator());
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
