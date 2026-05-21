import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../url/constant.dart';

class WeatherService {
  Future<WeatherModel> fetchWeather(String city) async {
    final url =
        "${AppConstants.forecastBaseUrl}?q=$city&appid=${AppConstants.apiKey}&units=metric";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw ("City Not Found");
    }

    final data = jsonDecode(response.body);
    final current = data['list'][0];

    return WeatherModel(
      city: data['city']['name'],

      // Temperature
      temp: (current['main']['temp'] as num).toDouble(),
      tempMin: (current['main']['temp_min'] as num).toDouble(),
      tempMax: (current['main']['temp_max'] as num).toDouble(),
      feelsLike: (current['main']['feels_like'] as num).toDouble(),

      // Condition
      condition: current['weather'][0]['main'],

      // Humidity
      humidity: current['main']['humidity'] as int,

      // Wind
      windSpeed: (current['wind']['speed'] as num).toDouble(),
      windDeg: (current['wind']['deg'] as num).toDouble(),

      // Visibility (metres → keep as int)
      visibility: (current['visibility'] as num).toInt(),

      // Pressure
      pressure: (current['main']['pressure'] as num).toInt(),

      // Hourly: next 12 slots (3hr each = 36hrs)
      hourly: data['list'],

      // Daily: same list, pick every 8th item (24hr apart)
      daily: data['list'],
    );
  }
}