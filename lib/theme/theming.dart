import 'package:flutter/material.dart';

class MyTheme {

  static const Color primaryColor = Colors.blue ;

  static ThemeData lightTheme = ThemeData(
    appBarTheme: AppBarTheme(
      color: Colors.transparent ,
      centerTitle: true ,
      elevation: 0
    ) ,
    textTheme: TextTheme(
      headline1: TextStyle(fontWeight: FontWeight.bold , fontSize: 20 , color: Colors.black),
      subtitle1: TextStyle(fontSize: 18 , fontWeight: FontWeight.w400)
    ),
    scaffoldBackgroundColor: Colors.transparent
  );

}