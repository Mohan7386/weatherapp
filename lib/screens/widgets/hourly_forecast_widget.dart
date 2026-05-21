import 'dart:ui';
import 'package:flutter/material.dart';

class HourlyForecastWidget extends StatelessWidget {
  final List hourly;
  const HourlyForecastWidget({super.key, required this.hourly});

  String _formatTime(String dtTxt, bool isNow) {
    if (isNow) return 'Now';
    final dt = DateTime.parse(dtTxt).toLocal();
    final h = dt.hour;
    final period = h >= 12 ? 'PM' : 'AM';
    final hour = h == 0 ? 12 : h > 12 ? h - 12 : h;
    return '$hour $period';
  }

  IconData _icon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':   return Icons.wb_sunny_rounded;
      case 'rain':    return Icons.water_drop_rounded;
      case 'drizzle': return Icons.grain;
      case 'clouds':  return Icons.cloud_rounded;
      case 'snow':    return Icons.ac_unit_rounded;
      case 'thunderstorm': return Icons.thunderstorm_rounded;
      default:        return Icons.wb_sunny_rounded;
    }
  }

  Color _iconColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':   return const Color(0xFFFFB300);
      case 'rain':
      case 'drizzle': return Colors.lightBlueAccent;
      case 'snow':    return Colors.white;
      default:        return Colors.white70;
    }
  }

  @override
  Widget build(BuildContext context) {
    final count = hourly.length > 12 ? 12 : hourly.length;

    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: count,
        itemBuilder: (_, i) {
          final item = hourly[i];
          final condition = item['weather'][0]['main'] as String;
          // REAL temp from API
          final temp = (item['main']['temp'] as num).round();
          final time = _formatTime(item['dt_txt'], i == 0);
          final isNow = i == 0;

          return _GlassCard(
            width: 90,
            isActive: isNow,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight:
                    isNow ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
                Icon(_icon(condition),
                    color: _iconColor(condition), size: 28),
                Text(
                  '$temp°',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  final double width;
  final bool isActive;
  const _GlassCard(
      {required this.child, this.width = double.infinity, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: width,
          margin: const EdgeInsets.only(right: 12),
          padding:
          const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.white.withOpacity(0.25)
                : Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white
                  .withOpacity(isActive ? 0.40 : 0.20),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}