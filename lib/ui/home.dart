import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/city.dart';
import '../models/constants.dart';
import '../widgets/weather_item.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Constants myConstants = Constants();

  //initiatilization
  int temperature = 0;
  int maxTemp = 0;
  String weatherStateName = 'Loading..';
  int humidity = 0;
  int windSpeed = 0;

  var currentDate = 'Loading..';
  String imageUrl = '';
  int woeid =
      44418; //This is the Where on Earth Id for London which is our default city
  String location = 'London'; //Our default city

  //get the cities and selected cities data
  var selectedCities = City.getSelectedCities();
  List<String> cities = [
    'London'
  ]; //the list to hold our selected cities. Deafult is London

  List consolidatedWeatherList = []; //To hold our weather data after api call

  //Api calls url
  String searchLocationUrl =
      'https://www.metaweather.com/api/location/search/?query='; //To get the woeid
  String searchWeatherUrl =
      'https://www.metaweather.com/api/location/'; //to get weather details using the woeid

  //Get the Where on earth id
  void fetchLocation(String location) async {
    var searchResult = await http.get(Uri.parse(searchLocationUrl + location));
    var result = json.decode(searchResult.body)[0];
    setState(() {
      woeid = result['woeid'];
    });
  }

  void fetchWeatherData() async {
    var weatherResult =
        await http.get(Uri.parse(searchWeatherUrl + woeid.toString()));
    var result = json.decode(weatherResult.body);
    var consolidatedWeather = result['consolidated_weather'];

    setState(() {
      for (int i = 0; i < 7; i++) {
        consolidatedWeather.add(consolidatedWeather[
            i]); //this takes the consolidated weather for the next six days for the location searched
      }
      //The index 0 referes to the first entry which is the current day. The next day will be index 1, second day index 2 etc...
      temperature = consolidatedWeather[0]['the_temp'].round();
      weatherStateName = consolidatedWeather[0]['weather_state_name'];
      humidity = consolidatedWeather[0]['humidity'].round();
      windSpeed = consolidatedWeather[0]['wind_speed'].round();
      maxTemp = consolidatedWeather[0]['max_temp'].round();

      //date formatting
      var myDate = DateTime.parse(consolidatedWeather[0]['applicable_date']);
      currentDate = DateFormat('EEEE, d MMMM').format(myDate);

      //set the image url
      imageUrl = weatherStateName
          .replaceAll(' ', '')
          .toLowerCase(); //remove any spaces in the weather state name
      //and change to lowercase because that is how we have named our images.

      consolidatedWeatherList = consolidatedWeather
          .toSet()
          .toList(); //Remove any instances of dublicates from our
      //consolidated weather LIST
    });
  }

  @override
  void initState() {
    fetchLocation(cities[0]);
    fetchWeatherData();

    //For all the selected cities from our City model, extract the city and add it to our original cities list
    for (int i = 0; i < selectedCities.length; i++) {
      cities.add(selectedCities[i].city);
    }
    super.initState();
  }

  //Create a shader linear gradient
  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xffABCFF2), Color(0xff9AC6F3)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
       body: Container(
         color: Color.fromARGB(112, 158, 148, 245),
         padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              location,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
            ),
            Text(
              currentDate,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              width: size.width,
              height: 200,
              decoration: BoxDecoration(
                  color: myConstants.primaryColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: myConstants.primaryColor.withOpacity(.5),
                      offset: const Offset(0, 25),
                      blurRadius: 10,
                      spreadRadius: -12,
                    )
                  ]),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -40,
                    left: 20,
                    child: imageUrl == ''
                        ? const Text('')
                        : Image.asset(
                            'assets/' + imageUrl + '.png',
                            width: 150,
                          ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 20,
                    child: Text(
                      weatherStateName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            temperature.toString(),
                            style: TextStyle(
                              fontSize: 80,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()..shader = linearGradient,
                            ),
                          ),
                        ),
                        Text(
                          'o',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()..shader = linearGradient,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  weatherItem(
                    text: 'Wind Speed',
                    value: windSpeed,
                    unit: 'km/h',
                    imageUrl: 'assets/windspeed.png',
                  ),
                  weatherItem(
                      text: 'Humidity',
                      value: humidity,
                      unit: '',
                      imageUrl: 'assets/humidity.png'),
                  weatherItem(
                    text: 'Wind Speed',
                    value: maxTemp,
                    unit: 'C',
                    imageUrl: 'assets/max-temp.png',
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Today',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                Text(
                  'Next 13 Days',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: myConstants.primaryColor),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
