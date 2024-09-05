import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies_2/utils/constant.dart';

import 'model/popular.dart';
class ApiManager{
  static const _url =
      "https://api.themoviedb.org/3/movie/popular?apikey=${Constant.apikey}";

  static Future<List<PopularResponse>> getPopular() async {
    final response = await http.get(Uri.parse(_url));
    if(response.statusCode==200){
      final json = jsonDecode(response.body)['results'] as List;
      print(json);
      return json.map((movie)=>PopularResponse.fromJson(movie)).toList();
    }else{
      throw Exception("Something went wrong");
    }
  }
}