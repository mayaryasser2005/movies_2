import 'package:flutter/material.dart';

import '../../API_model/category.dart';
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
          ],
        ),
      ),
    );
  }
}
