// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
//
// class WeatherScreen extends StatefulWidget {
//   @override
//   _WeatherScreenState createState() => _WeatherScreenState();
// }
//
// class _WeatherScreenState extends State<WeatherScreen> {
//   Map<String, dynamic>? responseData;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }
//
//   Future<void> fetchData() async {
//     final apiUrl = 'https://forecast9.p.rapidapi.com/rapidapi/forecast/mumbai/summary/';
//    // final apiKey = 'f8da56d13cmshb1e398f13f9d910p160936jsne13a477ff040';
//     final apiKey = 'cc88c8f592msh77b61539047165cp165c49jsn66a89c5c5b96';
//
//     try {
//       final response = await http.get(
//         Uri.parse(apiUrl),
//         headers: {
//           'X-RapidAPI-Key': apiKey,
//           'X-RapidAPI-Host': 'forecast9.p.rapidapi.com',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final decodedResponse = json.decode(response.body);
//         setState(() {
//           responseData = decodedResponse;
//         });
//       } else {
//         print('Failed to load data: ${response.statusCode}');
//       }
//     } catch (error) {
//       print('Error fetching data: $error');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Weather Forecast'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: responseData == null
//             ? const CircularProgressIndicator()
//             : Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Location: ${responseData!['location']['name']}',
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'Timezone: ${responseData!['location']['timezone']}',
//               style: TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Forecast:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//
//             Expanded(
//               child: ListView.builder(
//                 itemCount: responseData!['forecast']['items'].length,
//                 itemBuilder: (context, index) {
//                   final forecastItem = responseData!['forecast']['items'][index];
//                   return Card(
//                     margin: EdgeInsets.symmetric(vertical: 8),
//                     child: ListTile(
//                       title: Text('Date: ${forecastItem['date']}'),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Weather: ${forecastItem['weather']['text']}'),
//                           Text(
//                               'Temperature: ${forecastItem['temperature']['min']} - ${forecastItem['temperature']['max']} °C'),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:lottie/lottie.dart';
import 'package:wheather_stem_one/ui/home.dart';
import 'package:wheather_stem_one/widgets/weather_item.dart';

import '../main.dart';
import '../models/constants.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Constants myConstants = Constants();
  String imageUrl = '';
  String weatherStateName = 'Loading..';
  int temperature = 0;
  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xffABCFF2), Color(0xff9AC6F3)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));


  Map<String, dynamic>? responseData;
  int selectedDayIndex = 0;
  String selectedCity = 'mumbai'; // Updated default value for dropdown
  List<String> cities = [
    'mumbai',
    'pune',
    'delhi',
    'surat',
    'banglore',
    'New York',
    'San Francisco',
    'Dhule',
    'Nashik',
    'Miami',
    'Dubai',
    'japan',
    'London',
  ];

  @override
  void initState() {
    super.initState();
     fetchData();
  }

  Future<void> fetchData() async {
    final apiUrl = 'https://forecast9.p.rapidapi.com/rapidapi/forecast/$selectedCity/summary/';
   // final apiKey = 'cc88c8f592msh77b61539047165cp165c49jsn66a89c5c5b96';
  //  final apiKey = 'f8da56d13cmshb1e398f13f9d910p160936jsne13a477ff040';
     final apiKey = '5790644d63msh7847404a1288f43p17075cjsnf87ab411dbf4';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'X-RapidAPI-Key': apiKey,
          'X-RapidAPI-Host': 'forecast9.p.rapidapi.com',
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        setState(() {
          responseData = decodedResponse;
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }
  bool isContainerVisible = false;

  void toggleVisibility() {
    setState(() {
      isContainerVisible = !isContainerVisible;
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 0,
        backgroundColor: Color.fromARGB(112, 82, 64, 245),
        elevation: 0.0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Our profile image
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Image.asset(
                  'assets/CP.png',
                  width: 40,
                  height: 40,
                ),
              ),
              //our location dropdown
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/pin.png',
                    width: 20,
                  ),
                  const SizedBox(
                    width: 4,
                  ),

                  // DropdownButtonHideUnderline(
                  //   child: DropdownButton(
                  //       value: location,
                  //       icon: const Icon(Icons.keyboard_arrow_down),
                  //       items: cities.map((String location) {
                  //         return DropdownMenuItem(
                  //             value: location, child: Text(location));
                  //       }).toList(),
                  //       onChanged: (String? newValue) {
                  //         setState(() {
                  //           location = newValue!;
                  //           fetchLocation(location);
                  //           fetchWeatherData();
                  //         });
                  //       }),
                  // )
                ],
              )
            ],
          ),
        ),
        actions: [
          Container(
            child: DropdownButton<String>(
              itemHeight: 50,
              value: selectedCity,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCity = newValue!;
                });
                fetchData();
              },
              items: cities.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),

          // Padding(
           //   padding: const EdgeInsets.all(8.0),
           //   child: Container(
           //     color: Colors.redAccent,
           //     child: DropdownButtonFormField2(
           //       decoration: InputDecoration(
           //         filled:
           //         true, //<-- SEE HEREpackage:online_munim_native/screens/loan/itemListCard.dart:1429:23
           //         fillColor: Colors.white,
           //         isDense: true,
           //         contentPadding: EdgeInsets.zero,
           //         border: OutlineInputBorder(
           //           // borderRadius: BorderRadius.circular(7),
           //         ),
           //       ),
           //       isExpanded: true,
           //       hint: const Text(
           //         'Secured',
           //         style: TextStyle(
           //             color: Colors.black, fontSize: 12),
           //       ),
           //       icon: const Icon(
           //         Icons.arrow_drop_down,
           //         color: Colors.black45,
           //       ),
           //       iconSize: 30,
           //       buttonHeight: 40,
           //       buttonPadding:
           //       const EdgeInsets.only(left: 20, right: 10),
           //       dropdownDecoration: BoxDecoration(
           //         // borderRadius: BorderRadius.circular(7),
           //       ),
           //       items: cities
           //           .map((item) => DropdownMenuItem<String>(
           //         value: item,
           //         child: Text(
           //           item,
           //           style: const TextStyle(
           //             color: Colors.black,
           //             fontSize: 12,
           //           ),
           //         ),
           //       ))
           //           .toList(),
           //       validator: (value) {
           //         if (value == null) {
           //           return 'Select Firm.';
           //         }
           //       },
           //       onChanged: (value) {
           //         setState(() {
           //           selectedCity = value.toString();
           //         });
           //         print(selectedCity);
           //       },
           //     ),
           //   ),
           // ),

         /* Container(
            color: Colors.redAccent,
            child: DropdownButtonFormField2(
              decoration: InputDecoration(
                filled:
                true, //<-- SEE HEREpackage:online_munim_native/screens/loan/itemListCard.dart:1429:23
                fillColor: Colors.white,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  // borderRadius: BorderRadius.circular(7),
                ),
              ),
              isExpanded: true,
              hint: const Text(
                'Secured',
                style: TextStyle(
                    color: Colors.black, fontSize: 12),
              ),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.black45,
              ),
              iconSize: 30,
              buttonHeight: 40,
              buttonPadding:
              const EdgeInsets.only(left: 20, right: 10),
              dropdownDecoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(7),
              ),
              items: cities
                  .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
              ))
                  .toList(),
              validator: (value) {
                if (value == null) {
                  return 'Select Firm.';
                }
              },
              onChanged: (value) {
                setState(() {
                  selectedCity = value.toString();
                });
                print(selectedCity);
              },
            ),
          ),*/
        ],
      ),
      body: Container(
        color: Color.fromARGB(112, 158, 148, 245),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
          responseData ==
              null
              ? Home()
              :
          Column(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                        Text(
                          '${responseData!['location']['name']}',
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '${responseData!['location']['timezone']}',
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(height: 10),
                        Column(
                          children: [
                            Container(
                                width: size.width,
                                child: buildDayContainer(responseData!['forecast']['items'][selectedDayIndex])),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                           mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width : 130,
                              color: Color.fromARGB(112, 152, 186, 238),
                              height: 40,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                    Colors.blue
                                  )
                                ),
                                onPressed: () {
                                  onTap:toggleVisibility();
                                },
                                child:  Center(child: Text("Next 13 days",style: TextStyle(
                                    fontSize: 15 , fontWeight: FontWeight.bold),)),
                              )

                            ),
                          ],
                        ),
                        SizedBox(height: 20),

            ],
          ),

                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 300,
                      child: Visibility(
                        visible: isContainerVisible,
                        child: Container(
                          child: ListView.builder(
                            itemCount: responseData!['forecast']['items'].length,
                            itemBuilder: (context, index) {
                              final forecastItem = responseData!['forecast']['items'][index];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedDayIndex = index;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: buildSecondContainer(forecastItem),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),

        ),
      ),
    );
  }

  Widget buildDayContainer(Map<String, dynamic> forecastItem) {
     return Column(
       children: [
         Container(
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
                 bottom: 30,
                 left: 20,
                 child:
                 Row(
                     children: [
                     Text('${forecastItem['weather']['text']}',style: const TextStyle(
                       color: Colors.white,
                       fontSize: 20,
                     ),),
                   ],
                 ),
               ),
               Positioned(
                 bottom: 30,
                 right: 20,
                 child:
                 Row(
                     children: [
                       Text('${forecastItem['date']}',style: const TextStyle(
                         color: Color.fromARGB(255, 227, 216, 241),
                         fontSize: 20,
                       ),),
                   ],
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
                       child:

                       Text(
                         '${forecastItem['temperature']['min']} - ${forecastItem['temperature']['max']} °C',
                         style: TextStyle(
                           fontSize: 50,
                           fontWeight: FontWeight.bold,
                           foreground: Paint()..shader = linearGradient,
                         ),
                       ),
                     ),

                   ],
                 ),
               ),
               Positioned(
                 top: -3,
                 left: 1,
                 child:

                 Lottie.asset(
                   'assets/sun.json', // Replace with the path to your Lottie file
                   height: 130,
                   width: 150,
                   animate: true,
                 ),

               ),
             ],
           )
         ),
         SizedBox(height: 40,),
         Container(
           padding: const EdgeInsets.symmetric(horizontal: 40),
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Column(
                 children: [
                   Row(
                     children: [
                       Text('${forecastItem['wind']['max']}',style: const TextStyle(
                         color: Colors.blueAccent,
                         fontSize: 20,
                       ),),
                       Text(' ${forecastItem['wind']['unit']}',style: const TextStyle(
                         color: Colors.blueAccent,
                         fontSize: 13,
                       ),),
                     ],
                   ),
                   Text('${forecastItem['wind']['direction']}',style: const TextStyle(
                     color: Colors.blueAccent,
                     fontSize: 10,
                   ),),
                   SizedBox(height: 15,),
                   Image.asset(
                     'assets/windspeed.png',
                     height: 70,
                     width: 70,
                   ),
                 ],
               ),
               Column(
                 children: [
                   Text('${forecastItem['temperature']['min']}',style: const TextStyle(
                     color: Colors.blueAccent,
                     fontSize: 20,
                   ),),
                   Text('Min temp',style: const TextStyle(
                     color: Colors.blueAccent,
                     fontSize: 10,
                   ),),
                   SizedBox(height: 15,),
                   Image.asset(
                     'assets/humidity.png',
                       height: 70,
                       width: 70,
                   ),
                 ],
               ),
               Column(
                 children: [
                   Text('${forecastItem['temperature']['max']}',style: const TextStyle(
                     color: Colors.blueAccent,
                     fontSize: 20,
                   ),),
                   Text('Max temp',style: const TextStyle(
                     color: Colors.blueAccent,
                     fontSize: 10,
                   ),),
                   SizedBox(height: 15,),
                   Image.asset(
                     'assets/max-temp.png',
                     height: 70, // Set the height as needed
                     width: 70,  // Set the width as needed
                   ),
                 ],
               ),
             ],
           ),
         ),
       ],
     );
  }

  Widget buildSecondContainer(Map<String, dynamic> forecastItem) {
    return Container(
        height: 100,
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
              bottom: 10,
              left: 10,
              child:
              Row(
                children: [
                  Text('${forecastItem['weather']['text']}',style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),),
                ],
              ),
            ),
            Positioned(
              bottom: 8,
              right: 20,
              child:
              Row(
                children: [
                  Text('${forecastItem['date']}',style: const TextStyle(
                    color: Color.fromARGB(255, 227, 216, 241),
                    fontSize: 20,
                  ),),
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 20,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child:

                    Text(
                      '${forecastItem['temperature']['min']} - ${forecastItem['temperature']['max']} °C',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()..shader = linearGradient,
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        )
    );
  }

}



