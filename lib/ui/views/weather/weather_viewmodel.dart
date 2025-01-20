import 'package:stacked/stacked.dart';
import 'package:weather_app_bfs/app/app.locator.dart';
import 'package:weather_app_bfs/app/app.logger.dart';
import 'package:weather_app_bfs/core/models/forecast_model.dart';
import 'package:weather_app_bfs/core/models/weather_model.dart';
import 'package:weather_app_bfs/core/services/location_service.dart';
import 'package:weather_app_bfs/core/services/shared_prefs_service.dart';
import 'package:weather_app_bfs/core/services/weather_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_bfs/ui/views/weather/models/city_model.dart';
import 'package:weather_app_bfs/ui/views/weather/models/coord_model.dart';
import 'package:weather_app_bfs/ui/views/weather/models/forecast_ui_model.dart';
import 'package:weather_app_bfs/ui/views/weather/models/weather_ui_model.dart';

class WeatherViewModel extends BaseViewModel {
  final _weatherService = locator<WeatherService>();
  final _locationService = locator<LocationService>();
  final _sharedPrefsService = locator<SharedPrefsService>();
  final _log = getLogger('WeatherViewModel');

  WeatherUIModel? currentWeather;
  List<ForecastUIModel> forecastList = [];
  String selectedCity = 'Dortmund';

  final List<CityModel> availableCities = [
    CityModel('Dortmund', CoordUIModel(lon: 7.465298, lat: 51.513588)),
    CityModel('Berlin', CoordUIModel(lon: 13.404954, lat: 52.520008)),
    CityModel('Hannover', CoordUIModel(lon: 9.732010, lat: 52.375893)),
  ];

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String get currentDateTime =>
      DateFormat('EE - dd/MM/yyyy | hh:mm').format(DateTime.now());

  Future<void> initialize() async {
    setBusy(true);
    try {
      await _fetchWeatherAndForecast(selectedCity);
    } catch (e) {
      _log.e("Initialization Error: $e");
      _errorMessage =
          "Unable to load weather data. Please check your internet connection and try again.";
      _loadSavedLocation();
    } finally {
      setBusy(false);
    }
  }

  Future<void> updateCityWeather(String cityName) async {
    setBusy(true);
    try {
      selectedCity = cityName;
      final weather = await _fetchWeatherAndForecast(cityName);

      _saveLocation(weather);
    } catch (e) {
      _log.e("Error updating city weather: $e");
      _errorMessage = "Failed to fetch data for $cityName.";
    } finally {
      setBusy(false);
    }
  }

  Future<void> fetchCurrentLocationWeather() async {
    setBusy(true);
    try {
      final position = await _locationService.getCurrentLocation();

      final weather = await _weatherService.fetchWeatherByLatLon(
        position.latitude,
        position.longitude,
      );

      currentWeather = _mapWeatherModelToUiModel(weather);
      selectedCity = currentWeather?.cityName ?? 'Current Location';
      _addCityToList(
          selectedCity,
          CoordUIModel(
            lat: position.latitude,
            lon: position.longitude,
          ));

      final forecast = await _weatherService.fetchForecast(
        position.latitude,
        position.longitude,
      );
      forecastList = _mapForecastModelToUiModel(forecast);

      _saveLocation(weather);
    } catch (e) {
      _log.e("Error fetching weather for current location: $e");
      _errorMessage = "Unable to fetch location-based weather data.";
    } finally {
      setBusy(false);
    }
  }

  Future<WeatherModel> _fetchWeatherAndForecast(String cityName) async {
    final cityCoords =
        availableCities.firstWhere((city) => city.name == cityName).coord;

    final weather = await _weatherService.fetchWeatherByLatLon(
      cityCoords.lat,
      cityCoords.lon,
    );

    currentWeather = _mapWeatherModelToUiModel(weather);

    final forecast = await _weatherService.fetchForecast(
      cityCoords.lat,
      cityCoords.lon,
    );
    forecastList = _mapForecastModelToUiModel(forecast);

    notifyListeners();
    return weather;
  }

  void _saveLocation(WeatherModel weather) {
    final weatherJson = weatherModelToJson(weather);
    _sharedPrefsService.saveString('lastLocation', weatherJson);
    _log.i("Saved location: $weatherJson");
  }

  void _loadSavedLocation() {
    final savedLocationJson = _sharedPrefsService.getString('lastLocation');
    if (savedLocationJson?.isNotEmpty == true) {
      final savedWeather = weatherModelFromJson(savedLocationJson!);
      currentWeather = _mapWeatherModelToUiModel(savedWeather);
      selectedCity = currentWeather!.cityName;
      _addCityToList(
          selectedCity,
          CoordUIModel(
            lat: savedWeather.coord.lat,
            lon: savedWeather.coord.lon,
          ));
    } else {
      _log.w("No saved location found.");
    }
  }

  WeatherUIModel _mapWeatherModelToUiModel(WeatherModel model) {
    return WeatherUIModel(
      cityName: model.name,
      weatherDescription: model.weather.first.description,
      weatherIconPath: _getWeatherIconPath(model.weather.first.id),
      temperature: model.main.temp,
      feelsLikeTemperature: model.main.feels_like,
      humidity: model.main.humidity,
      precipitation: model.clouds.all,
      windSpeed: model.wind.speed,
      sunrise: _formatUnixTimestamp(model.sys.sunrise, model.timezone),
      sunset: _formatUnixTimestamp(model.sys.sunset, model.timezone),
      tempMax: model.main.temp_max,
      tempMin: model.main.temp_min,
    );
  }

  List<ForecastUIModel> _mapForecastModelToUiModel(
      ForecastModel forecastModel) {
    final forecasts = forecastModel.list?.map((item) {
          final date = item.dt != null
              ? DateFormat('EEE, dd MMM').format(
                  DateTime.fromMillisecondsSinceEpoch(item.dt! * 1000),
                )
              : "Unknown Date";

          final temperature = item.main?.temp ?? 0.0;
          final weatherType = item.weather?.isNotEmpty == true
              ? item.weather!.first.main?.name ?? "Unknown"
              : "Unknown";
          final weatherId = item.weather?.isNotEmpty == true
              ? item.weather!.first.id ?? 0
              : 0;

          return ForecastUIModel(
            date: date,
            temperature: temperature,
            weatherType: weatherType,
            iconPath: _getWeatherIconPath(weatherId),
          );
        }).toList() ??
        [];

    return _filterDailyForecasts(forecasts);
  }

  List<ForecastUIModel> _filterDailyForecasts(List<ForecastUIModel> forecasts) {
    final filtered = <String, ForecastUIModel>{};

    for (var forecast in forecasts) {
      final dateKey = forecast.date.split(',').last.trim();
      if (!filtered.containsKey(dateKey) ||
          forecast.date.contains('12:00 PM')) {
        filtered[dateKey] = forecast;
      }
    }

    return filtered.values.toList();
  }

  String _getWeatherIconPath(int code) {
    if (code >= 200 && code < 300) return 'assets/images/thunderstorm.png';
    if (code >= 300 && code < 400) return 'assets/images/drizzle.png';
    if (code >= 500 && code < 600) return 'assets/images/rain.png';
    if (code >= 600 && code < 700) return 'assets/images/snow.png';
    if (code >= 700 && code < 800) return 'assets/images/atmosphere.png';
    if (code == 800) return 'assets/images/clear.png';
    if (code > 800) return 'assets/images/clouds.png';
    return 'assets/images/unknown.png';
  }

  String _formatUnixTimestamp(int timestamp, [int? timezone]) {
    final date = DateTime.fromMillisecondsSinceEpoch(
      (timestamp + (timezone ?? 0)) * 1000,
    );
    return DateFormat('hh:mm a').format(date);
  }

  void _addCityToList(String cityName, CoordUIModel coords) {
    if (availableCities.every((city) => city.name != cityName)) {
      availableCities.add(CityModel(cityName, coords));
    }
  }
}
