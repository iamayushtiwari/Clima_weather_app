import '../services/location.dart';
import '../services/networking.dart';

const apiKey = '853bec14608c51b083cbaf9579b5403d';
const longURL = 'https://api.openweathermap.org/data/2.5/weather';

class WeatherModel {
  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }

  Future<dynamic> getCityWeatherData(String cityName) async {
    NetworkHelper weather =
        NetworkHelper(url: '$longURL?q=$cityName&appid=$apiKey');
    var weatherData = await weather.getData();
    return weatherData;
  }

  Future<dynamic> getWeatherData() async {
    Location location = Location();
    await location.getLocation();
    NetworkHelper weather = NetworkHelper(
        url:
            '$longURL?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey');
    var weatherData = await weather.getData();
    return weatherData;
  }
}
