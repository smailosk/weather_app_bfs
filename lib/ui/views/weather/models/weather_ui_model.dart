class WeatherUIModel {
  final String cityName;
  final String weatherDescription;
  final String weatherIconPath;
  final double temperature;
  final double feelsLikeTemperature;
  final int humidity;
  final int precipitation;
  final double windSpeed;
  final String sunrise;
  final String sunset;
  final double tempMax;
  final double tempMin;

  WeatherUIModel({
    required this.cityName,
    required this.weatherDescription,
    required this.weatherIconPath,
    required this.temperature,
    required this.feelsLikeTemperature,
    required this.humidity,
    required this.precipitation,
    required this.windSpeed,
    required this.sunrise,
    required this.sunset,
    required this.tempMax,
    required this.tempMin,
  });
}
