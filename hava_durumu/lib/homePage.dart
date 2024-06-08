import 'package:flutter/material.dart';
import 'weather_app1.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  final String apiKey = '42bfb0a421b341a1a3decd4475f7af05'; 
  WeatherApp? weatherApp;
  String cityName = 'London';
  String temperature = '';
  String feelsLike = '';
  String description = '';
  String iconCode = '';

  @override
  void initState() {
    super.initState();
    weatherApp = WeatherApp(apiKey);
    _fetchWeather(cityName);
  }

  Future<void> _fetchWeather(String cityName) async {
    try {
      final data = await weatherApp!.fetchWeather(cityName);
      setState(() {
        temperature = data['main']['temp'].toString();
        feelsLike = data['main']['feels_like'].toString();
        description = data['weather'][0]['description'];
        iconCode = data['weather'][0]['icon'];
      });
    } catch (e) {
      setState(() {
        temperature = 'Error';
        description = 'Could not fetch weather data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('Weather App'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Enter City',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        cityName = _controller.text;
                        _fetchWeather(cityName);
                      });
                    },
                  ),
                ),
                onSubmitted: (value) {
                  setState(() {
                    cityName = value;
                    _fetchWeather(cityName);
                  });
                },
              ),
              SizedBox(height: 20),
              Text(
                cityName.toUpperCase(),
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                '$temperature°C',
                style: TextStyle(fontSize: 52, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              Text(
                'Feels like $feelsLike°C',
                style: TextStyle(fontSize: 20, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              if (iconCode.isNotEmpty)
                Image.network(
                  'http://openweathermap.org/img/wn/$iconCode@2x.png',
                  width: 100,
                  height: 100,
                ),
              Text(
                description.toUpperCase(),
                style: TextStyle(fontSize: 24, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              Spacer(),
              Text(
                'Last updated at ${DateTime.now().hour}:${DateTime.now().minute}',
                style: TextStyle(fontSize: 16, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
