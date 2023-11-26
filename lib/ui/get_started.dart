//
// import 'package:flutter/material.dart';
//
// import '../Login/Phone_Otp.dart';
// import '../models/constants.dart';
// import 'Wheather_Homepage.dart';
//
//
// class GetStarted extends StatelessWidget {
//   const GetStarted({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     Constants myConstants = Constants();
//
//     Size size = MediaQuery.of(context).size;
//
//     return Scaffold(
//       body: Container(
//         width: size.width,
//         height: size.height,
//         color: myConstants.primaryColor.withOpacity(.5),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//
//             children: [
//               Image.asset('assets/get-started.png'),
//               const SizedBox(height: 30,),
//               GestureDetector(
//                 onTap: (){
//                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>   OtpLogin()));
//                 },
//                 child: Container(
//                   height: 50,
//                   width: size.width * 0.7,
//                   decoration: BoxDecoration(
//                     color: myConstants.primaryColor,
//                     borderRadius: const BorderRadius.all(Radius.circular(10)),
//                   ),
//                   child: const Center(
//                     child: Text('Get started', style: TextStyle(color: Colors.white, fontSize: 18),),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Login/Phone_Otp.dart';
import '../models/constants.dart';
import 'Wheather_Homepage.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();

    // Function to check if the mobile number is stored in shared preferences
    Future<bool> isMobileNumberStored() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.containsKey('globalphone');
    }

    return FutureBuilder<bool>(
      future: isMobileNumberStored(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Future is still in progress, show a loading indicator or placeholder
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Future has an error, handle it accordingly
          return Text('Error: ${snapshot.error}');
        } else {
          // Future completed successfully, check the result
          bool isNumberStored = snapshot.data ?? false;

          return Scaffold(

            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: myConstants.primaryColor.withOpacity(.5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/get-started.png'),
                    const SizedBox(height: 30,),
                    GestureDetector(
                      onTap: () {
                        if (isNumberStored) {
                          // Mobile number is found, navigate to the home page
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WeatherScreen()));
                        } else {
                          // Mobile number is not found, navigate to the OTP login page
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OtpLogin()));
                        }
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                          color: myConstants.primaryColor,
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: const Center(
                          child: Text('Get started', style: TextStyle(color: Colors.white, fontSize: 18),),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            bottomNavigationBar:
            Container(
              color: myConstants.primaryColor.withOpacity(.5),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Developed By Chetan Patil', style: TextStyle(color: Colors.blue, fontSize: 15),),
              ),
            ),
          );
        }
      },
    );
  }
}
