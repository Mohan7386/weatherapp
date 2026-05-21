class WeatherModel {
  final String city;
  final double temp;
  final double tempMin;
  final double tempMax;
  final double feelsLike;
  final String condition;
  final int humidity;
  final double windSpeed;
  final double windDeg;
  final int visibility;
  final int pressure;
  final List hourly;
  final List daily;

  WeatherModel({
    required this.city,
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.feelsLike,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.windDeg,
    required this.visibility,
    required this.pressure,
    required this.hourly,
    required this.daily,
  });
}