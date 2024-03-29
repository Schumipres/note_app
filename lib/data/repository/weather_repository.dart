import 'dart:convert';

import 'package:todo_app/data/data_provider/weather_data_provider.dart';
import 'package:todo_app/models/weather_model.dart';

class WeatherRepository {
  final WeatherDataProvider weatherDataProvider;
  WeatherRepository(this.weatherDataProvider);

  Future<WeatherModel> getCurrentWeather(String cityName) async {
    try {
      final weatherData = await weatherDataProvider.getCurrentWeather(cityName);

      final data = jsonDecode(weatherData);

      if (data['cod'] != '200') {
        throw data['message'];
      }

      return WeatherModel.fromJson(weatherData);
    } catch (e) {
      throw e.toString();
    }
  }
}
