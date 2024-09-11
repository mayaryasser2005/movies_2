import 'package:flutter/cupertino.dart';

import '../API_model/similar_movie.dart';
import '../utils/constant.dart';

class SimilarSlider extends StatelessWidget {
  const SimilarSlider({super.key, required this.similarMovieResponse});

  final SimilarMovieResponse similarMovieResponse;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: similarMovieResponse.results?.length,
          itemBuilder: (context, index) {
            print("test: ${similarMovieResponse.results}");
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                      height: 200,
                      width: 150,
                      child: Image.network(
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.cover,
                          "${Constant.imagePath}${similarMovieResponse.results?[index].posterPath}"))),
            );
          }),
    );
  }
}
