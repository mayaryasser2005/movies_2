import 'package:flutter/material.dart';

import '../API_model/api_widget_response.dart';
import '../firebase_model/firebase_functions.dart';
import '../firebase_model/movie_model.dart';
import '../screens/movie_details.dart';
import '../utils/constant.dart';

class NewReleasesSlider extends StatelessWidget {
  const NewReleasesSlider({super.key, required this.results});

  final ApiWidgetResponse results;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: results.results?.length,
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
                                "${Constant.imagePath}${results.results?[index]
                                    .posterPath}")
                        )
                    ),
                    // widget.movieModel.isDone ?
                    //     Icon(Icons.done, color: Colors.amber,)
                    //     :
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
              ),
            );
          }),
    );
  }
}
