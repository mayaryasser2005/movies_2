import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/NewReleases.dart';
import '../screens/movie_details.dart';
import '../screens/tabs/listwatch.dart';
import '../utils/constant.dart';

class NewReleasesSlider extends StatelessWidget {
  const NewReleasesSlider({super.key, required this.results});

  final NewReleasesResponse results;
  @override
  Widget build(BuildContext context) {
    bool isAddedList = false;
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          itemCount: 10,
          itemBuilder: (context ,index){
            var movie = results.results?[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
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
                child: Stack(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                            height: 200,
                            width: 150,
                            child: Image.network(
                                filterQuality: FilterQuality.high,
                                fit: BoxFit.cover,
                                "${Constant.imagePath}${results.results?[index].posterPath}"))),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(5)),
                      width: 33,
                      height: 33,
                      child: IconButton(
                        icon: isAddedList == true
                            ? Icon(
                                Icons.done,
                                size: 20,
                                color: Colors.black,
                              )
                            : Icon(
                                Icons.add,
                                size: 20,
                                color: Colors.black,
                              ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
