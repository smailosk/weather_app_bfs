// To parse this JSON data, do
//
//     final forecastModel = forecastModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'forecast_model.freezed.dart';
part 'forecast_model.g.dart';

ForecastModel forecastModelFromJson(String str) =>
    ForecastModel.fromJson(json.decode(str));

String forecastModelToJson(ForecastModel data) => json.encode(data.toJson());

@freezed
class ForecastModel with _$ForecastModel {
  const factory ForecastModel({
    @JsonKey(name: "cod") String? cod,
    @JsonKey(name: "message") int? message,
    @JsonKey(name: "cnt") int? cnt,
    @JsonKey(name: "list") List<ListElement>? list,
    @JsonKey(name: "city") City? city,
  }) = _ForecastModel;

  factory ForecastModel.fromJson(Map<String, dynamic> json) =>
      _$ForecastModelFromJson(json);
}

@freezed
class City with _$City {
  const factory City({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "coord") Coord? coord,
    @JsonKey(name: "country") String? country,
    @JsonKey(name: "population") int? population,
    @JsonKey(name: "timezone") int? timezone,
    @JsonKey(name: "sunrise") int? sunrise,
    @JsonKey(name: "sunset") int? sunset,
  }) = _City;

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
}

@freezed
class Coord with _$Coord {
  const factory Coord({
    @JsonKey(name: "lat") double? lat,
    @JsonKey(name: "lon") double? lon,
  }) = _Coord;

  factory Coord.fromJson(Map<String, dynamic> json) => _$CoordFromJson(json);
}

@freezed
class ListElement with _$ListElement {
  const factory ListElement({
    @JsonKey(name: "dt") int? dt,
    @JsonKey(name: "main") MainClass? main,
    @JsonKey(name: "weather") List<Weather>? weather,
    @JsonKey(name: "clouds") Clouds? clouds,
    @JsonKey(name: "wind") Wind? wind,
    @JsonKey(name: "visibility") int? visibility,
    @JsonKey(name: "pop") double? pop,
    @JsonKey(name: "sys") Sys? sys,
    @JsonKey(name: "dt_txt") DateTime? dtTxt,
    @JsonKey(name: "rain") Rain? rain,
  }) = _ListElement;

  factory ListElement.fromJson(Map<String, dynamic> json) =>
      _$ListElementFromJson(json);
}

@freezed
class Clouds with _$Clouds {
  const factory Clouds({
    @JsonKey(name: "all") int? all,
  }) = _Clouds;

  factory Clouds.fromJson(Map<String, dynamic> json) => _$CloudsFromJson(json);
}

@freezed
class MainClass with _$MainClass {
  const factory MainClass({
    @JsonKey(name: "temp") double? temp,
    @JsonKey(name: "feels_like") double? feelsLike,
    @JsonKey(name: "temp_min") double? tempMin,
    @JsonKey(name: "temp_max") double? tempMax,
    @JsonKey(name: "pressure") int? pressure,
    @JsonKey(name: "sea_level") int? seaLevel,
    @JsonKey(name: "grnd_level") int? grndLevel,
    @JsonKey(name: "humidity") int? humidity,
    @JsonKey(name: "temp_kf") double? tempKf,
  }) = _MainClass;

  factory MainClass.fromJson(Map<String, dynamic> json) =>
      _$MainClassFromJson(json);
}

@freezed
class Rain with _$Rain {
  const factory Rain({
    @JsonKey(name: "3h") double? the3H,
  }) = _Rain;

  factory Rain.fromJson(Map<String, dynamic> json) => _$RainFromJson(json);
}

@freezed
class Sys with _$Sys {
  const factory Sys({
    @JsonKey(name: "pod") Pod? pod,
  }) = _Sys;

  factory Sys.fromJson(Map<String, dynamic> json) => _$SysFromJson(json);
}

enum Pod {
  @JsonValue("d")
  D,
  @JsonValue("n")
  N
}

final podValues = EnumValues({"d": Pod.D, "n": Pod.N});

@freezed
class Weather with _$Weather {
  const factory Weather({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "main") MainEnum? main,
    @JsonKey(name: "description") Description? description,
    @JsonKey(name: "icon") String? icon,
  }) = _Weather;

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);
}

enum Description {
  @JsonValue("broken clouds")
  BROKEN_CLOUDS,
  @JsonValue("clear sky")
  CLEAR_SKY,
  @JsonValue("few clouds")
  FEW_CLOUDS,
  @JsonValue("light rain")
  LIGHT_RAIN,
  @JsonValue("overcast clouds")
  OVERCAST_CLOUDS,
  @JsonValue("scattered clouds")
  SCATTERED_CLOUDS
}

final descriptionValues = EnumValues({
  "broken clouds": Description.BROKEN_CLOUDS,
  "clear sky": Description.CLEAR_SKY,
  "few clouds": Description.FEW_CLOUDS,
  "light rain": Description.LIGHT_RAIN,
  "overcast clouds": Description.OVERCAST_CLOUDS,
  "scattered clouds": Description.SCATTERED_CLOUDS
});

enum MainEnum {
  @JsonValue("Clear")
  CLEAR,
  @JsonValue("Clouds")
  CLOUDS,
  @JsonValue("Rain")
  RAIN
}

final mainEnumValues = EnumValues({
  "Clear": MainEnum.CLEAR,
  "Clouds": MainEnum.CLOUDS,
  "Rain": MainEnum.RAIN
});

@freezed
class Wind with _$Wind {
  const factory Wind({
    @JsonKey(name: "speed") double? speed,
    @JsonKey(name: "deg") int? deg,
    @JsonKey(name: "gust") double? gust,
  }) = _Wind;

  factory Wind.fromJson(Map<String, dynamic> json) => _$WindFromJson(json);
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
