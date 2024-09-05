import 'dart:convert';

import 'package:movies_2/utils/constant.dart';

import 'model/popular.dart';
import 'package:http/http.dart' as http;
class ApiManager{
  // static const url = "https://api.themoviedb.org/3/movie/popular?apikey=${Constant.apikey}";

  Future<List<PopularResponse>> getPopular() async {
    Uri url = Uri.https("api.themoviedb.org","3/movie/popular",{
      "apikey":Constant.apikey,
    });
    http.Response response = await http.get(url);
    if(response.statusCode==200){
      final json = jsonDecode(response.body)['results'] as List;
      print(json);
      return json.map((movie)=>PopularResponse.fromJson(movie)).toList();
    }else{
      throw Exception("Something went wrong");
    }
  }
}