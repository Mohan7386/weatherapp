import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  IconData getIcon(String condition) {
    switch (condition.toLowerCase()) {
      case "clouds":
        return Icons.cloud;
      case "rain":
        return Icons.water_drop;
      case "clear":
        return Icons.wb_sunny;
      default:
        return Icons.wb_cloudy;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Weather App"), centerTitle: true),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "Enter city",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      print("clicked");
                      context.read<WeatherProvider>().fetchWeather(
                        controller.text,
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: Builder(
                    builder: (_) {
                      switch (provider.state) {
                        case WeatherState.loading:
                          return const CircularProgressIndicator();

                        case WeatherState.error:
                          return Text(
                            provider.error,
                            style: const TextStyle(color: Colors.red),
                          );

                        case WeatherState.success:
                          final w = provider.weather!;
                          return Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    w.city,
                                    style: const TextStyle(fontSize: 26),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "${w.temperature} °C",
                                    style: const TextStyle(fontSize: 42),
                                  ),
                                  const SizedBox(height: 10),
                                  Icon(getIcon(w.condition), size: 80),
                                  Text(w.condition),
                                  const SizedBox(height: 10),
                                  Text("Humidity: ${w.humidity}%"),
                                ],
                              ),
                            ),
                          );

                        default:
                          return const Text(
                            "Search a city to see weather",
                            style: TextStyle(fontSize: 16),
                          );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
