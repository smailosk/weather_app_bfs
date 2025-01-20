import 'package:flutter/material.dart';
import 'package:weather_app_bfs/ui/views/weather/weather_viewmodel.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:weather_app_bfs/ui/common/app_colors.dart';

class WeatherSection extends StatelessWidget {
  final WeatherViewModel viewModel;

  const WeatherSection({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weatherUI = viewModel.currentWeather;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: primaryBlue,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: Colors.white,
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      value: viewModel.selectedCity,
                      items: viewModel.availableCities.map((city) {
                        return DropdownMenuItem<String>(
                          value: city.name,
                          child: Text(
                            city.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (city) {
                        if (city != null) {
                          viewModel.updateCityWeather(city);
                        }
                      },
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          color: primaryBlue.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            viewModel.currentDateTime,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
              fontWeight: FontWeight.w400,
            ),
          ),
          Image.asset(
            weatherUI!.weatherIconPath,
            height: 180,
            width: 180,
            fit: BoxFit.cover,
          ),
          Text(
            '${weatherUI.temperature.round()}°',
            style: const TextStyle(
              fontSize: 60,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            weatherUI.weatherDescription,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
