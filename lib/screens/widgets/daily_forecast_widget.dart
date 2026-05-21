import 'dart:ui';
import 'package:flutter/material.dart';

class DailyForecastWidget extends StatelessWidget {
  final List daily;
  const DailyForecastWidget({super.key, required this.daily});

  IconData _icon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':        return Icons.wb_sunny_rounded;
      case 'rain':
      case 'drizzle':      return Icons.water_drop_rounded;
      case 'clouds':       return Icons.cloud_rounded;
      case 'snow':         return Icons.ac_unit_rounded;
      case 'thunderstorm': return Icons.thunderstorm_rounded;
      default:             return Icons.wb_sunny_rounded;
    }
  }

  Color _iconColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':        return const Color(0xFFFFB300);
      case 'rain':
      case 'drizzle':      return Colors.lightBlueAccent;
      default:             return Colors.white70;
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // Group list by date → pick max/min per day (REAL API data)
    final Map<String, List> grouped = {};
    for (final item in daily) {
      final dt = DateTime.parse(item['dt_txt']).toLocal();
      final key =
          '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(item);
    }

    final days = grouped.entries.take(7).toList();

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.18)),
          ),
          child: Column(
            children: List.generate(days.length, (index) {
              final entry = days[index];
              final items = entry.value;
              final dt = DateTime.parse(items[0]['dt_txt']).toLocal();

              // REAL high/low from API per day
              double high = double.negativeInfinity;
              double low  = double.infinity;
              String condition = items[0]['weather'][0]['main'];

              for (final item in items) {
                final tMax = (item['main']['temp_max'] as num).toDouble();
                final tMin = (item['main']['temp_min'] as num).toDouble();
                if (tMax > high) {
                  high = tMax;
                  condition = item['weather'][0]['main'];
                }
                if (tMin < low) low = tMin;
              }

              String dayLabel;
              if (dt.day == now.day)          dayLabel = 'Today';
              else if (dt.day == now.day + 1) dayLabel = 'Tomorrow';
              else                             dayLabel = _weekday(dt.weekday);

              final isToday = dayLabel == 'Today';
              final isLast  = index == days.length - 1;

              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  border: isLast
                      ? null
                      : Border(
                      bottom: BorderSide(
                          color: Colors.white.withOpacity(0.10))),
                ),
                child: Row(
                  children: [
                    // Day name
                    SizedBox(
                      width: 90,
                      child: Text(
                        dayLabel,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: isToday
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                    // Icon
                    Expanded(
                      child: Center(
                        child: Icon(_icon(condition),
                            color: _iconColor(condition), size: 26),
                      ),
                    ),
                    // High — REAL
                    Text(
                      '${high.round()}°',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: isToday
                            ? FontWeight.w700
                            : FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Low — REAL
                    Text(
                      '${low.round()}°',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.50),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  String _weekday(int w) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[(w - 1).clamp(0, 6)];
  }
}