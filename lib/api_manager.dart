import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies_2/utils/constant.dart';

import 'model/popular.dart';

class ApiManager {
  static const Map<String, String> headers = {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9...",
    "accept": "application/json"
  };

  static Future<PopularResponse> getPopular() async {
    Uri url = Uri.https(Constant.BaseURL, "3/movie/popular", {
      "language": "en-US",
      "page": "1",
    });
    var response = await http.get(url, headers: headers);
    var jsonFile = jsonDecode(response.body);
    var popularResponse = PopularResponse.fromJson(jsonFile);
    return popularResponse;
  }
}
