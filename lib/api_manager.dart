import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies_2/utils/constant.dart';

import 'API_model/api_widget_response.dart';
import 'API_model/category.dart';
import 'API_model/movie_details.dart';

class ApiManager {
  static const Map<String, String> headers = {
    "Authorization":
        "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkZTU2Yzg2MzZiOTExOTBhMDdkNmExOWM5OWYyMDgzYyIsInN1YiI6IjY1NDE1Yzg3YjY4NmI5MDBlMTE4MDg1YiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.45qrNJVRNiUMtYid_qmIp5kKJ_Q0Obk-yRRywYsGgP8",
    "accept": "application/json"
  };

  Future<ApiWidgetResponse> getPopular() async {
    var url = Uri.https(Constant.BaseURL, "3/movie/popular", {
      "language": "en-US",
      "page": "1",
    });

    var response = await http.get(url, headers: headers);
    var jsonFile = jsonDecode(response.body);
    var popularResponse = ApiWidgetResponse.fromJson(jsonFile);
    return popularResponse;
  }

  Future<ApiWidgetResponse> getRecent() async {
    var url = Uri.https(Constant.BaseURL, "/3/movie/upcoming", {
      "language": "en-US",
    });

    var response = await http.get(url, headers: headers);
    var jsonFile = jsonDecode(response.body);
    var releasesResponse = ApiWidgetResponse.fromJson(jsonFile);
    return releasesResponse;
  }

  Future<ApiWidgetResponse> getRecomended() async {
    var url = Uri.https(Constant.BaseURL, "/3/movie/top_rated", {
      "language": "en-US",
    });

    var response = await http.get(url, headers: headers);
    var jsonFile = jsonDecode(response.body);
    var releasesResponse = ApiWidgetResponse.fromJson(jsonFile);
    return releasesResponse;
  }

  Future<ApiWidgetResponse> getSearchMovies(String query) async {
    Uri url = Uri.https(Constant.BaseURL, "3/search/movie",
        {"language": "en_US", "query": query});
    var response = await http.get(url, headers: headers);
    var json = jsonDecode(response.body);
    ApiWidgetResponse results = ApiWidgetResponse.fromJson(json);
    return results;
  }

  Future<MovieDitalesResponse> getMovieDetails(num movieId) async {
    Uri url =
        Uri.https(Constant.BaseURL, "/3/movie/$movieId", {"language": "en_US"});
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

  Future<ApiWidgetResponse> getSimilarMovies(num sameMovieID) async {
    print("70-getSimilarMovies $sameMovieID");
    Uri url = Uri.https(Constant.BaseURL, "/3/movie/$sameMovieID/similar",
        {"language": "en_US"});
    print("70: ${url.toString()}");
    var response = await http.get(url, headers: headers);
    var json = jsonDecode(response.body);
    print("83- json: $json ");
    ApiWidgetResponse similar = ApiWidgetResponse.fromJson(json);
    return similar;
  }

  Future<CategoriesResponse> getCategoryMovie() async {
    Uri url = Uri.https(
        Constant.BaseURL, "3/genre/movie/list", {"language": "en_US"});
    var response = await http.get(url, headers: headers);
    var json = jsonDecode(response.body);
    CategoriesResponse results = CategoriesResponse.fromJson(json);
    return results;
  }

  Future<ApiWidgetResponse> getCategoryListMovie(num id) async {
    Uri url = Uri.https(Constant.BaseURL, "3/discover/movie", {
      "language": "en_US",
      "with_genres": id.toString(),
    });
    try {
      var response = await http.get(url, headers: headers);
      var json = jsonDecode(response.body); //success //success
      ApiWidgetResponse results =
          ApiWidgetResponse.fromJson(json); //fail??? //success
      print(results); //fail???? //success?? HOW ?!?!?!
      return results;
    } catch (e) {
      print(e.toString());
    }
    print("object");
    return ApiWidgetResponse();
  }
}