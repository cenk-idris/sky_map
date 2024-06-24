import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/star_model.dart';

class StarsApiService {
  String baseUrl = dotenv.env['STARS_API_URL'] ?? '';
  String apiKey = dotenv.env['STARS_API_KEY'] ?? '';

  Uri buildUrl(String constellation) {
    Uri uri = Uri.parse(baseUrl);
    uri = uri.replace(query: 'constellation=$constellation');
    return uri;
  }

  Future<List<Star>> getAllStars() async {
    // We will be making at least 3 request to grab
    final response =
        await http.get(buildUrl('Ursa Minor'), headers: {'X-Api-Key': apiKey});

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw Exception(response.statusCode);
    }

    return [];
  }
}
