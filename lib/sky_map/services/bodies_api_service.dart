import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sky_map/sky_map/models/celestial_body_model.dart';

class BodiesApiService {
  final Position position;
  String baseUrl = dotenv.env['BODIES_API_URL'] ?? '';
  String bodiesAppId = dotenv.env['BODIES_APP_ID'] ?? '';
  String bodiesAppSecret = dotenv.env['BODIES_APP_SECRET'] ?? '';

  BodiesApiService(this.position);

  Uri buildUrl(String baseUrl, Map<String, String> params) {
    Uri uri = Uri.parse(baseUrl);
    uri = uri.replace(queryParameters: params);
    return uri;
  }

  Future<List<CelestialBody>> getAllCelestialBodies() async {
    // prepare params map
    String dateValue = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String timeValue = DateFormat('HH:mm:ss').format(DateTime.now());
    Map<String, String> params = {
      'latitude': position.latitude.toString(),
      'longitude': position.longitude.toString(),
      'elevation': position.altitude.toString(),
      'from_date': dateValue,
      'to_date': dateValue,
      'time': timeValue,
      'output': 'table'
    };

    Uri uri = buildUrl('$baseUrl/bodies/positions', params);

    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$bodiesAppId:$bodiesAppSecret'))}';

    var response = await http.get(uri, headers: {
      'Authorization': basicAuth,
    });

    if (response.statusCode == 200) {
      //print(response.body);
      final parsedJson = jsonDecode(response.body);

      List<CelestialBody> celestialBodyList = [];

      var rows = parsedJson['data']['table']['rows'];
      for (var row in rows) {
        var cells = row['cells'];
        for (var cell in cells) {
          celestialBodyList.add(CelestialBody.fromJson(cell));
        }
      }
      //print(celestialBodyList);
      return celestialBodyList;
    } else {
      throw Exception(response.statusCode);
    }
  }
}
