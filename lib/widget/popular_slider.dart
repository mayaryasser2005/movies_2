import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies_2/model/popular.dart';
import 'package:movies_2/utils/constant.dart';

class PopularSlider extends StatelessWidget {
  const PopularSlider({super.key, required this.results});

  final List<PopularResponse> results;
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
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 300,
                      width: 400,
                      child:Image.network(
                      filterQuality:FilterQuality.high,
                    fit: BoxFit.cover,
                          "${Constant.imagePath}${results[index]}")
                )
              );
            },
          ),
      )
      ],
    );


  }
}
