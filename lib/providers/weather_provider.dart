import 'package:flutter/material.dart';

import '../models/weather_model.dart';
import '../repositories/weather_repository.dart';

enum WeatherState {
  idle,
  loading,
  success,
  error,
}

class WeatherProvider
    extends ChangeNotifier {

  final WeatherRepository _repository =
  WeatherRepository();

  WeatherModel? weather;

  WeatherState state =
      WeatherState.idle;

  String error = "";

  Future<void> fetchWeather(
      String city) async {

    try {

      state = WeatherState.loading;

      notifyListeners();

      weather =
      await _repository.getWeather(
        city,
      );

      state = WeatherState.success;

    } catch (e) {
      weather = null;
      error = "City Not Found";
      state = WeatherState.error;
    }

    notifyListeners();
  }
}
