class Weather {
  final String city;
  final double temperature;
  final String condition;
  final int humidity;

  Weather({
    required this.city,
    required this.temperature,
    required this.condition,
    required this.humidity,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    print("JSON DATA: $json");

    return Weather(
      city: json['name'] ?? "Unknown",
      temperature: (json['main']?['temp'] ?? 0).toDouble(),
      condition: json['weather'] != null && json['weather'].length > 0
          ? json['weather'][0]['main']
          : "Unknown",
      humidity: json['main']?['humidity'] ?? 0,
    );
  }

}