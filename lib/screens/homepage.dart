import 'package:flutter/material.dart';
import 'package:traxion/components/elevated_button.dart';
import 'package:traxion/components/textfield.dart';
import 'package:traxion/service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final cityController = TextEditingController();
  final Service weatherService = Service();
  String result = '';
  bool isJson = true;
  bool loading = false;

  void fetchWeather() async {
    setState(() {
      loading = true;
      result = '';
    });

    String city = cityController.text.trim();
    if (city.isEmpty) {
      setState(() {
        result = 'Please enter a city';
        loading = false;
      });
      return;
    }

    try {
      var weatherData = await weatherService.fetchWeatherJson(city);
      setState(() {
        result = '${weatherData['name']}\n'
            '${weatherData['description']}\n'
            '${weatherData['temp']}°C\n'
            '${weatherData['humidity']}%\n'
            '${weatherData['speed']}\n'
            '${weatherData['pressure']}\n';
      });
    } catch (e) {
      setState(() {
        result = 'Error fetching weather data: $e';
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Traxion')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFieldWidget(
              controller: cityController,
            ),
            ElevatedButtonWidget(
              onPressed: loading ? null : fetchWeather,
              child: Text(
                loading ? 'Loading...' : 'Submit',
              ),
            ),
            const SizedBox(height: 40),
            loading
                ? const CircularProgressIndicator()
                : result.isNotEmpty
                    ? _buildWeatherResult()
                    : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherResult() {
    final resultLines = result.split('\n');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          resultLines[0],
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: Colors.indigo[900],
              ),
        ),
        const SizedBox(height: 20),
        Text(
          resultLines[1],
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.indigo[800],
          ),
        ),
        const SizedBox(height: 50),
        Text(
          resultLines[2],
          style: TextStyle(
            fontSize: 48,
            color: Colors.indigo[600],
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            weatherTile('Humidity', resultLines[3]),
            weatherTile('Wind Speed', resultLines[4]),
            weatherTile('Pressure', resultLines[5]),
          ],
        ),
      ],
    );
  }

  Widget weatherTile(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.indigo[800],
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.indigo[900],
          ),
        ),
      ],
    );
  }
}
