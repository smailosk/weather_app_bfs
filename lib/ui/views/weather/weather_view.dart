import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:weather_app_bfs/ui/common/app_colors.dart';
import 'package:weather_app_bfs/ui/views/weather/widgets/forecast_section.dart';
import 'package:weather_app_bfs/ui/views/weather/widgets/weather_details_section.dart';
import 'package:weather_app_bfs/ui/views/weather/widgets/weather_section.dart';

import 'weather_viewmodel.dart';

class WeatherView extends StackedView<WeatherViewModel> {
  const WeatherView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    WeatherViewModel viewModel,
    Widget? child,
  ) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  if (viewModel.currentWeather != null) ...[
                    WeatherSection(viewModel: viewModel),
                    const SizedBox(height: 20),
                    WeatherDetailsSection(viewModel: viewModel),
                    ForecastSection(viewModel: viewModel),
                    const SizedBox(height: 20),
                  ] else if (!viewModel.isBusy)
                    Center(
                      child: Text(
                        viewModel.errorMessage,
                        style: const TextStyle(fontSize: 20, color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
            if (viewModel.isBusy)
              Container(
                color: Colors.black.withOpacity(0.9),
                child: Center(
                  child: Image.asset(
                    'assets/gif/animation.gif',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await viewModel.fetchCurrentLocationWeather();
          },
          tooltip: 'My Location',
          backgroundColor: primaryBlue,
          child: const Icon(
            Icons.my_location,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  WeatherViewModel viewModelBuilder(BuildContext context) => WeatherViewModel();

  @override
  void onViewModelReady(WeatherViewModel viewModel) {
    viewModel.initialize();
  }
}
