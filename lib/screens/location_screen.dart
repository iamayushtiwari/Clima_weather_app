import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import '../services/weather.dart';
import 'city_screen.dart';

WeatherModel weatherModel = WeatherModel();
int temperature;
String cityName;
String conditionEmogi;
String message;

class LocationScreen extends StatefulWidget {
  final locationData;

  LocationScreen({this.locationData});
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    updateUi(widget.locationData);
  }

  void updateUi(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        conditionEmogi = 'error';
        message = 'Something goes wrong';
        cityName = '';
      } else {
        double temperatureDouble = weatherData['main']['temp'] - 272.15;
        temperature = temperatureDouble.toInt();
        conditionEmogi =
            weatherModel.getWeatherIcon(weatherData['weather'][0]['id']);
        message = weatherModel.getMessage(temperature);
        cityName = weatherData['name'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.7), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      updateUi(await WeatherModel().getWeatherData());
                      // print(await WeatherModel().getWeatherData());
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      var inputText = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CityScreen()));

                      if (inputText != null) {
                        WeatherModel cityWeather = WeatherModel();
                        var weatherData =
                            await cityWeather.getCityWeatherData(inputText);
                        updateUi(weatherData);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      conditionEmogi,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "$message in $cityName !",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
