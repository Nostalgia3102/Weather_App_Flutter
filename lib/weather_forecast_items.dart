import 'package:flutter/material.dart';


class HourlyForecastCard extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;
  const HourlyForecastCard({super.key, required this.time, required this.icon, required this.temp});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 120,
      child: Card(
        elevation: 6,
        child: Container(
          width: 100,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8,),
              Text(time,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                ),),
              const SizedBox(height: 5,),
              Icon(icon, size: 28,),
              const SizedBox(height: 5,),
              Text(temp, style: const TextStyle(
                fontSize: 16,
              ),)
            ],
          ),
        ),
      ),
    );
  }
}


class AdditionalInfoCardWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const AdditionalInfoCardWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.value
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const SizedBox(height: 5,),
            Icon(icon, size:32),
            const SizedBox(height: 7,),
            Text(label, style: const TextStyle(
                fontSize: 16
            ),),
            const SizedBox(height: 5,),
            Text(value, style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 5,),
          ],
        ),
      ),
    );
  }
}

