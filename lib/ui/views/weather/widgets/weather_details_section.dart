import 'package:flutter/material.dart';
import 'package:weather_app_bfs/ui/views/weather/weather_viewmodel.dart';

class WeatherDetailsSection extends StatelessWidget {
  final WeatherViewModel viewModel;

  const WeatherDetailsSection({Key? key, required this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weatherUI = viewModel.currentWeather;

    if (weatherUI == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weather Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: DetailItem(
                  iconPath: 'assets/images/sunrise.png',
                  label: 'Sunrise',
                  value: weatherUI.sunrise,
                ),
              ),
              Expanded(
                child: DetailItem(
                  iconPath: 'assets/images/sunset.png',
                  label: 'Sunset',
                  value: weatherUI.sunset,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: DetailItem(
                  iconPath: 'assets/images/temp_max.png',
                  label: 'Temp Max',
                  value: '${weatherUI.tempMax.round()}°C',
                ),
              ),
              Expanded(
                child: DetailItem(
                  iconPath: 'assets/images/temp_min.png',
                  label: 'Temp Min',
                  value: '${weatherUI.tempMin.round()}°C',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DetailItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final String value;

  const DetailItem({
    Key? key,
    required this.iconPath,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(iconPath, scale: 8),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
