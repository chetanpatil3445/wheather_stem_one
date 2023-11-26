import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wheather_stem_one/ui/Wheather_Homepage.dart';
import 'package:wheather_stem_one/ui/get_started.dart';

final Shader linearGradient = const LinearGradient(
  colors: <Color>[Color(0xffABCFF2), Color(0xff9AC6F3)],
).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
     home:  GetStarted(),
    );
  }
}

