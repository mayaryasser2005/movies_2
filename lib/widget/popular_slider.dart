import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies_2/model/popular.dart';
import 'package:movies_2/utils/constant.dart';

import '../screens/movie_details.dart';

class PopularSlider extends StatelessWidget {
  const PopularSlider({super.key, required this.results});

  final PopularResponse results;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          width: double.infinity,
          child: CarouselSlider.builder(
            itemCount: 10,
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
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                            height: 300,
                            width: 400,
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
              );
            },
          ),
      )
      ],
    );
  }
}
