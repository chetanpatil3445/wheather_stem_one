import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

import '../ui/Wheather_Homepage.dart';
import 'Phone_Otp.dart';


class OTPVERIFY extends StatefulWidget {
  @override
  State<OTPVERIFY> createState() => _OTPVERIFYState();
}

class _OTPVERIFYState extends State<OTPVERIFY> {

  var code = "";
  final FirebaseAuth auth = FirebaseAuth.instance;

  int _counter = 30;
  late Timer _timer;


  @override
  void initState() {
    super.initState();

    // Start the countdown timer
    _startTimer();
  }
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          // Timer reached zero, you can perform any action here
          _timer.cancel(); // Stop the timer
        }
      });
    });
  }
  @override
  void dispose() {
    // Cancel the timer to avoid memory leaks
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('PIN Input Example'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  child:
                  Lottie.asset(
                    'assets/otp.json', // Replace with the path to your Lottie file
                    height: 250,
                    width: 250,
                    animate: true,
                  ),
                ),
                Text("OTP",style: TextStyle(
                  color:Color.fromARGB(176, 27, 7, 173),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),),
                SizedBox(height: 20,),
                Text("Enter your 6 digit code",style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),),
                 SizedBox(height: 20,),
                PinInputTextField(
                  onChanged:  (value) {
                    code = value;
                  },
                  pinLength: 6,
                  // You can set the length of the PIN
                  decoration: UnderlineDecoration(
                    colorBuilder: PinListenColorBuilder(Colors.black, Colors.blue),
                    textStyle: TextStyle(fontSize: 20.0, color: Colors.black),
                  ),
                  autoFocus: true,
                  textInputAction: TextInputAction.done,
                  onSubmit: (pin) {
                    // Use the entered PIN
                    print('Entered PIN: $pin');
                  },
                ),
                SizedBox(height: 30,),

                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(

                    children: [

                      Container(
                        height: 60,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                           try{
                             PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: OtpLogin.verify, smsCode: code);
                             // Sign the user in (or link) with the credential
                             await auth.signInWithCredential(credential);
                             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> WeatherScreen()));
                           }
                           catch(e){
                             final snackBar = SnackBar(
                               content: Text('Invalid OTP. Please try again.'),
                               duration: Duration(seconds: 3),
                             );

                             // Find the Scaffold in the widget tree and show the SnackBar
                             ScaffoldMessenger.of(context).showSnackBar(snackBar);
                           }
                          },
                          child: Text("Verify OTP", style: TextStyle(
                             fontSize: 22,
                            fontWeight: FontWeight.bold
                          ),),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$_counter sec',
                            style: TextStyle(
                              fontSize: 20,
                                color: Colors.red,
                                fontWeight:FontWeight.bold,

                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap:  () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> OtpLogin()));
                              },
                              child: Text("Send Otp Again",style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight:FontWeight.bold,
                                  fontSize: 17
                              ),),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );

  }

  }
