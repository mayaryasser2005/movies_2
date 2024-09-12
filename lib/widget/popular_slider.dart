import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movies_2/firebase_model/firebase_functions.dart';
import 'package:movies_2/firebase_model/movie_model.dart';
import 'package:movies_2/utils/constant.dart';

import '../API_model/api_widget_response.dart';
import '../screens/movie_details.dart';

class PopularSlider extends StatelessWidget {
  const PopularSlider({super.key, required this.results});

  final ApiWidgetResponse results;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          width: double.infinity,
          child: CarouselSlider.builder(
            itemCount: results.results?.length,
            options: CarouselOptions(
              height: 300,
              autoPlay: true,
              viewportFraction: 0.55,
              enlargeCenterPage: true,
              autoPlayCurve: Curves.fastLinearToSlowEaseIn,
              autoPlayAnimationDuration: const Duration(seconds: 1),
            ),
            itemBuilder: (context,index,pageViewIndex){
              var movie = results.results?[index];
              return InkWell(
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
                            height: 300,
                            width: 400,
                            child: Image.network(
                                filterQuality: FilterQuality.high,
                                fit: BoxFit.cover,
                                "${Constant.imagePath}${results.results?[index].posterPath}"))),
                    Container(
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(43, 45, 48, 0.7),
                          borderRadius: BorderRadius.circular(8)),
                      width: 40,
                      height: 40,
                      child: IconButton(
                        onPressed: () {
                          MovieModel movie = MovieModel(
                            title: "${results.results![index].originalTitle}",
                            description: "${results.results![index].overview}",
                            date: "${results.results![index].releaseDate}",
                            image: "${results.results![index].posterPath}",
                            id: results.results![index].id as int,
                          );
                          FirebaseFunctions.addMovie(movie);
                          movie.isDone = true;
                          FirebaseFunctions.updateMovie(movie);
                        },
                        icon: const Icon(
                          Icons.add,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
