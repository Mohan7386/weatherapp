import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../url/constant.dart';

class WeatherService {
  Future<Weather> fetchWeather(String city) async {
    final url =
        "${AppConstants.baseurl}?q=$city&appId=${AppConstants.apiKey}&units=metric";

    final response = await http.get(Uri.parse(url));

    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE BODY: ${response.body}");

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception("City not found");
    } else {
      throw Exception("Something went wrong");
    }
  }
}