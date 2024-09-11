import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:movies_2/firebase_model/firebase_functions.dart';

import '../../utils/constant.dart';
import '../movie_details.dart';

class ListWatch extends StatefulWidget {
  static const String routeNamed = "ListWatch";

  ListWatch({super.key});

  @override
  State<ListWatch> createState() => _ListWatchState();
}

class _ListWatchState extends State<ListWatch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Watch List",
              style: TextStyle(fontSize: 25),
            ),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder(
              future: FirebaseFunctions.getMovie(),
              builder: (context, snapshot) {
                var movies =
                    snapshot.data?.docs.map((e) => e.data()).toList() ?? [];
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                if (movies.isEmpty) {
                  return const Center(child: Text("No Movies"));
                } else if (snapshot.hasData) {
                  // التأكد من الوصول إلى 'results' في 'PopularResponse'
                  return Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: movies.length,
                      // Check if results are null
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetails(
                                  movieID:
                                      movies[index].id ?? 0, // Ensure valid ID
                                ),
                              ),
                            );
                          },
                          child: Slidable(
                            startActionPane: ActionPane(
                              motion: DrawerMotion(),
                              extentRatio: 0.3,
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    // FirebaseFunctions.deleteTask(movieModel.id as int );
                                  },
                                  label: "Delete",
                                  icon: Icons.delete,
                                  spacing: 8,
                                  backgroundColor: Colors.redAccent,
                                  padding: EdgeInsets.zero,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      bottomLeft: Radius.circular(25)),
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          height: 100,
                                          width: 175,
                                          child: Image.network(
                                            filterQuality: FilterQuality.high,
                                            fit: BoxFit.cover,
                                            "${Constant.imagePath}${movies[index].image}",
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      width: 33,
                                      height: 33,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          size: 20,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {},
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  children: [
                                    SizedBox(
                                      width: 200,
                                      child: Text(
                                        movies[index].title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 200,
                                      child: Text(
                                        movies[index].date,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 13, color: Colors.grey),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 200,
                                      child: Text(
                                        movies[index].description,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 13, color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
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
            ),
          ],
        ),
      ),
    );
  }
}
