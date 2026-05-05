import 'package:flutter/cupertino.dart';
import 'package:weatherapp/repositories/weather_repository.dart';

import '../models/weather_model.dart';

enum WeatherState { idle, loading, success, error}

class WeatherProvider extends ChangeNotifier {
  final WeatherRepository _repository = WeatherRepository();

  Weather? _weather;
  WeatherState _state = WeatherState.idle;
  String _error = "";

  Weather? get weather => _weather;
  WeatherState get state => _state;
  String get error => _error;

  Future<void> fetchWeather(String city) async{
    print("FETCH WEATHER CALLED");
    _state = WeatherState.loading;
    notifyListeners();

    try {
      _weather = await _repository.getWeather(city);
      _state = WeatherState.success;
    } catch(e) {
      _error = e.toString();
      _state = WeatherState.error;
    }
    notifyListeners();
  }
}
