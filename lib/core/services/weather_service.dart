import 'package:weather_app_bfs/core/models/forecast_model.dart';
import 'package:weather_app_bfs/core/models/weather_model.dart';
import 'package:dio/dio.dart';

class WeatherService {
  static const String _apiKey = "d16d476239bff9abed68bc656c544e5a";
  static const String _baseUrl =
      "https://api.openweathermap.org/data/2.5/weather";

  static const String forecastUrl =
      "https://api.openweathermap.org/data/2.5/forecast";

  final Dio _dio;
  WeatherService([Dio? dio])
      : _dio = dio ??
            Dio(BaseOptions(
              sendTimeout: const Duration(seconds: 1),
              connectTimeout: const Duration(seconds: 1),
              receiveTimeout: const Duration(seconds: 1),
            ));

  Future<WeatherModel> fetchWeatherByLatLon(
    double latitude,
    double longitude,
  ) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'lat': latitude,
          'lon': longitude,
          'appid': _apiKey,
          'units': 'metric',
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return WeatherModel.fromJson(response.data);
      } else {
        throw Exception("Failed to fetch weather data");
      }
    } catch (e) {
      throw Exception("Error fetching weather data: $e");
    }
  }

  Future<ForecastModel> fetchForecast(double latitude, double longitude) async {
    try {
      final response = await _dio.get(
        forecastUrl,
        queryParameters: {
          'lat': latitude,
          'lon': longitude,
          'appid': _apiKey,
          'units': 'metric',
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return ForecastModel.fromJson(response.data);
      } else {
        throw Exception("Failed to fetch forecast data");
      }
    } catch (e) {
      throw Exception("Error fetching forecast data: $e");
    }
  }
}
