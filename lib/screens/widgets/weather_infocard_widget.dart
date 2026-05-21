import 'dart:ui';
import 'package:flutter/material.dart';

class WeatherInfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;
  final String subtitle;
  final String unit;

  const WeatherInfoCard({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    required this.subtitle,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),

      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),

        child: Container(
          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),

            borderRadius: BorderRadius.circular(30),

            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /// TOP
              Row(
                children: [
                  Icon(icon, color: Colors.white54, size: 20),

                  const SizedBox(width: 8),

                  Text(
                    title.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 14,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),

              /// VALUE
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,

                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 5),

                    child: Text(
                      unit,

                      style: const TextStyle(
                        color: Colors.white70,

                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              /// SUBTITLE
              Text(
                subtitle,

                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
