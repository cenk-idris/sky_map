import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:sky_map/sky_map/constants.dart';

import '../models/star_model.dart';

class StarsApiService {
  String baseUrl = dotenv.env['STARS_API_URL'] ?? '';
  String apiKey = dotenv.env['STARS_API_KEY'] ?? '';

  Uri buildUrl(String constellation) {
    Uri uri = Uri.parse(baseUrl);
    uri = uri.replace(query: 'constellation=$constellation');
    return uri;
  }

  Future<List<Star>> getAllStarsInConstellation() async {
    // We will be making at least 3 request to fill the starsList
    // with different constellations
    List<Star> starsList = [];

    for (var constellation in constellationStars.keys) {
      final response = await http
          .get(buildUrl(constellation), headers: {'X-Api-Key': apiKey});

      if (response.statusCode == 200) {
        final List<dynamic> parsedJson = jsonDecode(response.body);

        for (var starJson in parsedJson) {
          if (constellationStars[constellation]!.contains(starJson['name'])) {
            starsList.add(Star.fromJson(starJson));
          }
        }
      } else {
        throw Exception(response.statusCode);
      }
    }

    return starsList;
  }
}
