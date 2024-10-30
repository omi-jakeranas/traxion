import 'package:http/http.dart' as http;
import 'dart:convert';

class Service {
  final String apiKey = '9fc39737762bd342b8c59d2660f88424';

  Future<Map<String, dynamic>> fetchWeatherJson(String city) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['weather'] != null && data['weather'].isNotEmpty) {
          String name = data['name'];
          String description = data['weather'][0]['description'];
          double temp = data['main']['temp'];
          int humidity = data['main']['humidity'];
          double wind = data['wind']['speed'];
          int pressure = data['main']['pressure'];

          return {
            'name': name,
            'description': description,
            'temp': temp,
            'humidity': humidity,
            'speed': wind,
            'pressure': pressure,
          };
        } else {
          throw Exception("Not available");
        }
      } catch (e) {
        throw Exception('Error parsing JSON: $e');
      }
    } else {
      throw Exception(
          'Failed to load weather data. Status: ${response.statusCode}');
    }
  }
}
