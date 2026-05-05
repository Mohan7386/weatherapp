import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherRepository {
  final WeatherService _service = WeatherService();

  Future<Weather> getWeather(String city) async {
    return await _service.fetchWeather(city);
  }
}