import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ListClass.dart';

class Services {
  static String url =
      "https://temp-8ec02-default-rtdb.firebaseio.com/TempDateData.json";
  static Future<List<GeoTempData>> getUsers() async {
    try {
      final response = await http.get(Uri.parse(url));
      // print(response.body);
      if (response.statusCode == 200) {
        List<GeoTempData> list = parseUsers(response.body);
        return list;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static List<GeoTempData> parseUsers(String responseBody) {
    // print(responseBody);
    final parsed = json.decode(responseBody);
    // print(parsed.runtimeType);
    List<GeoTempData> data = [];
    parsed.forEach((key, value) => {
          data.add(GeoTempData.fromJson(parsed[key])),
        });
    return data;
  }
}
