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
            const SizedBox(
              height: 25,
            ),
            Container(
              margin: const EdgeInsets.only(left: 25),
              child: const Text(
                "Browser Category",
                style: TextStyle(fontSize: 25, color: Colors.amber),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            const CategoryItem()
          ],
        ),
      ),
    );
  }
}
