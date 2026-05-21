import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/screens/widgets/daily_forecast_widget.dart';
import 'package:weatherapp/screens/widgets/hourly_forecast_widget.dart';
import 'package:weatherapp/screens/widgets/weather_infocard_widget.dart';

import '../providers/weather_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<WeatherProvider>().fetchWeather("Hyderabad");
    });
  }

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
    final weather = provider.weather;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,

            colors: [Color(0xff67B7FF), Color(0xff4A91FF), Color(0xff2B60DE)],
          ),
        ),

        child: SafeArea(
          child: provider.state == WeatherState.error
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_off,
                  color: Colors.white,
                  size: 70,
                ),
                const SizedBox(height: 16),
                Text(
                  provider.error,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () {
                    provider.fetchWeather("Hyderabad");
                  },

                  child: const Text("Retry"),
                ),
              ],
            ),
          )
              : weather == null
              ? const SizedBox()
              : SingleChildScrollView(
            padding: const EdgeInsets.all(18),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                /// SEARCH
                TextField(
                  controller: controller,

                  style: const TextStyle(color: Colors.white),

                  onSubmitted: (value) {
                    provider.fetchWeather(value);
                  },

                  decoration: InputDecoration(
                    hintText: "Search City",

                    hintStyle: const TextStyle(color: Colors.white70),

                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),

                    filled: true,

                    fillColor: Colors.white24,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),

                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                /// CURRENT WEATHER
                Center(
                  child: Column(
                    children: [
                      Icon(
                        getIcon(weather.condition),
                        size: 120,
                        color: weather.condition.toLowerCase() == "clear"
                            ? Colors.amber
                            : weather.condition.toLowerCase() == "rain"
                            ? Colors.lightBlueAccent
                            : weather.condition.toLowerCase() == "clouds"
                            ? Colors.white
                            : Colors.white,
                      ),

                      const SizedBox(height: 20),

                      Text(
                        weather.city,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      Text(
                        "${weather.temp.round()}°",

                        style: const TextStyle(
                          color: Colors.white,

                          fontSize: 100,

                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        weather.condition,

                        style: const TextStyle(
                          color: Colors.white70,

                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                /// HOURLY TITLE
                const Text(
                  "HOURLY FORECAST",
                  style: TextStyle(
                    color: Colors.white70,

                    letterSpacing: 2,

                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 18),

                /// HOURLY FORECAST

                HourlyForecastWidget(hourly: weather.hourly),
                const SizedBox(height: 30),

                /// 7 DAY TITLE
                const Text(
                  "7-DAY FORECAST",

                  style: TextStyle(
                    color: Colors.white70,

                    letterSpacing: 2,

                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 18),

                /// DAILY FORECAST
                DailyForecastWidget(
                  daily: weather.daily,
                ),

                const SizedBox(height: 30),

                const Text(
                  "CURRENT DETAILS",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(height: 18),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.95,

                  children: [
                    WeatherInfoCard(
                      title: "WIND",
                      icon: Icons.air,
                      value:
                      "${weather.hourly[0]['wind']['speed'].round()}",
                      unit: "km/h",
                      subtitle:
                      "${weather.hourly[0]['wind']['deg']}° direction",
                    ),

                    WeatherInfoCard(
                      title: "HUMIDITY",
                      icon: Icons.water_drop_outlined,
                      value: "${weather.humidity}",
                      unit: "%",
                      subtitle: "Current humidity",
                    ),

                    WeatherInfoCard(
                      title: "VISIBILITY",
                      icon: Icons.remove_red_eye_outlined,
                      value:
                      "${(weather.hourly[0]['visibility'] / 1000).round()}",
                      unit: "km",
                      subtitle: "Clear atmosphere",
                    ),

                    WeatherInfoCard(
                      title: "PRESSURE",
                      icon: Icons.speed,
                      value: "${weather.hourly[0]['main']['pressure']}",
                      unit: "hPa",
                      subtitle: "Atmospheric pressure",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
