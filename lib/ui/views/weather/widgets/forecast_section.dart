import 'package:flutter/material.dart';
import 'package:weather_app_bfs/ui/views/weather/weather_viewmodel.dart';
import 'package:weather_app_bfs/ui/views/weather/models/forecast_ui_model.dart';

class ForecastSection extends StatelessWidget {
  final WeatherViewModel viewModel;

  const ForecastSection({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (viewModel.forecastList.isEmpty) {
      return const Center(child: Text('No forecast data available.'));
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '5-Day Prediction',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: viewModel.forecastList.length,
            itemBuilder: (context, index) {
              final forecast = viewModel.forecastList[index];
              return ForecastTile(forecast: forecast);
            },
          ),
        ],
      ),
    );
  }
}

class ForecastTile extends StatelessWidget {
  final ForecastUIModel forecast;

  const ForecastTile({Key? key, required this.forecast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffF7F9FA),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(forecast.date, style: const TextStyle(fontSize: 16)),
          Text(
            '${forecast.temperature.round()}°',
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            forecast.weatherType,
            style: const TextStyle(fontSize: 16),
          ),
          Image.asset(
            forecast.iconPath,
            height: 50,
            width: 50,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error, color: Colors.red);
            },
          ),
        ],
      ),
    );
  }
}
