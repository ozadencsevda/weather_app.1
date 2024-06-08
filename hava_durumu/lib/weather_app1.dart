import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherApp {
  final String apiKey;

  WeatherApp(this.apiKey);

  Future<Map<String, dynamic>> fetchWeather(String cityName) async {
    final url = 'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
