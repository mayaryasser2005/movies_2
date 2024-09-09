import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies_2/model/movie_details.dart';
import 'package:movies_2/model/similar_movie.dart';
import 'package:movies_2/utils/constant.dart';

import 'model/NewReleases.dart';
import 'model/Recomended.dart';
import 'model/popular.dart';
import 'model/search.dart';

class ApiManager {
  static const Map<String, String> headers = {
    "Authorization":
        "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkZTU2Yzg2MzZiOTExOTBhMDdkNmExOWM5OWYyMDgzYyIsInN1YiI6IjY1NDE1Yzg3YjY4NmI5MDBlMTE4MDg1YiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.45qrNJVRNiUMtYid_qmIp5kKJ_Q0Obk-yRRywYsGgP8",
    "accept": "application/json"
  };

  Future<PopularResponse> getPopular() async {
    var url = Uri.https(Constant.BaseURL, "3/movie/popular", {
      "language": "en-US",
      "page": "1",
    });

    var response = await http.get(url, headers: headers);
    var jsonFile = jsonDecode(response.body);
    var popularResponse = PopularResponse.fromJson(jsonFile);
    return popularResponse;
  }

  Future<NewReleasesResponse> getRecent() async {
    var url = Uri.https(Constant.BaseURL, "/3/movie/upcoming", {
      "language": "en-US",
    });

    var response = await http.get(url, headers: headers);
    var jsonFile = jsonDecode(response.body);
    var releasesResponse = NewReleasesResponse.fromJson(jsonFile);
    return releasesResponse;
  }

  Future<RecomendedResponse> getRecomended() async {
    var url = Uri.https(Constant.BaseURL, "/3/movie/top_rated", {
      "language": "en-US",
    });

    var response = await http.get(url, headers: headers);
    var jsonFile = jsonDecode(response.body);
    var releasesResponse = RecomendedResponse.fromJson(jsonFile);
    return releasesResponse;
  }

  Future<SearchRespones> getSearchMovies(String query) async {
    Uri url = Uri.https(Constant.BaseURL, "3/search/movie",
        {"language": "en_US", "query": query});
    var response = await http.get(url, headers: headers);
    var json = jsonDecode(response.body);
    SearchRespones results = SearchRespones.fromJson(json);
    return results;
  }

  Future<MovieDitalesResponse> getMovieDetails(num movieId) async {
    Uri url = Uri.https(
        Constant.BaseURL, "/3/movie/${movieId}", {"language": "en_US"});
    try {
      var response = await http.get(url, headers: headers);
      var json = jsonDecode(response.body);
      MovieDitalesResponse filmDetail = MovieDitalesResponse.fromJson(json);
      return filmDetail;
    } catch (e) {
      print(e.toString());
    }
    return MovieDitalesResponse();
  }

  Future<SimilarMovieResponse> getSimilarMovies(num samemovieID) async {
    Uri url = Uri.https(Constant.BaseURL, "/3/movie/$samemovieID/similar",
        {"language": "en_US"});
    var response = await http.get(url, headers: headers);
    var json = jsonDecode(response.body);
    SimilarMovieResponse similar = SimilarMovieResponse.fromJson(json);
    return similar;
  }
}