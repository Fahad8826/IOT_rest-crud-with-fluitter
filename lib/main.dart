import 'package:flutter/material.dart';
import 'package:iot_flutter/USER_CRUD/fetch_data.dart';
import 'package:iot_flutter/login.dart';
import 'package:iot_flutter/signup.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/detailspage':(context)=> DataListingPage(),
        '/signup':(context)=> SignUpPage(),
      },
      title: 'Flutter Demo',
      home: LoginPage(),
    );
  }
}
