import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'Verify_Otp.dart';

  var globalphone = "";
class OtpLogin extends StatefulWidget {
  const OtpLogin({Key? key}) : super(key: key);

  static String verify = "";

  @override
  State<OtpLogin> createState() => _OtpLoginState();
}

class _OtpLoginState extends State<OtpLogin> {
  bool _isLoading = false;

  void _startLoading() {
    setState(() {
      _isLoading = true;
    });

    // Simulate a time-consuming task
    Future.delayed(Duration(seconds: 30), () {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('please try again or \nYour Number Is blocked By Firebase\ntry again tomorrow'),
          duration: Duration(seconds: 5),
        ),
      );
    });
  }

  TextEditingController phoneController = TextEditingController();
String phone = "";
String CountryCode = "+91";

int _counter = 30;
late Timer _timer;


@override
void initState() {
  super.initState();
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
    return   Scaffold(
      backgroundColor: Color.fromARGB(207, 191, 191, 241),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(176, 27, 7, 173),
      ),
      body: SingleChildScrollView(
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
              SizedBox(height: 20,),
              Text("Welcome",style: TextStyle(
                color:Color.fromARGB(176, 27, 7, 173),
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),),
              SizedBox(height: 20,),
              Text("Enter number to continue",style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Phone number",style: TextStyle(
                      color: Color.fromARGB(176, 27, 7, 173),
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: phoneController,
                      onChanged: (value) {
                        phone = value;
                        globalphone = value;
                      },
                       keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: "Enter Number"
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 60,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(176, 27, 7, 173),
                        )
                    ),
                    onPressed: () async {
                      _startLoading();
                      _startTimer();
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: '${CountryCode.toString()+phone}',
                        verificationCompleted: (PhoneAuthCredential credential) {},
                        verificationFailed: (FirebaseAuthException e) {},
                        codeSent: (String verificationId, int? resendToken) {
                          OtpLogin.verify=verificationId;
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>   OTPVERIFY()));
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                      );
                    },
                    child: Text("Continue", style: TextStyle(
                      fontSize: 25
                    ),),
                  ),
                ),
              ),
              SizedBox(height: 50,),
              Container(
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text("")
              ),
            ],
          ),
      ),
    );
  }
}
