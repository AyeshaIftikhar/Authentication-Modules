import 'package:flutter/material.dart';

// Normal Theme
var theme = ThemeData(
  backgroundColor: Colors.white, 
  primaryColor: Colors.cyan, 
  primarySwatch: Colors.cyan, 
  accentColor: Colors.cyanAccent,
  brightness: Brightness.light,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  appBarTheme: AppBarTheme(
    color: Colors.cyan,
    textTheme: TextTheme(button: TextStyle(color: Colors.white),),
    iconTheme: IconThemeData(color: Colors.white)
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.cyan,
    foregroundColor: Colors.white,
    elevation: 2.0, 
  ),
  primaryIconTheme: IconThemeData(color: Colors.cyan),
  primaryTextTheme: TextTheme(caption: TextStyle(color: Colors.black))
);
// darkmode theme
var darktheme = ThemeData(
  backgroundColor: Colors.black,
  primaryColor: Colors.cyan,
  primarySwatch: Colors.cyan,
  accentColor: Colors.cyanAccent,
  brightness: Brightness.dark,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  appBarTheme: AppBarTheme(
    color: Colors.cyan,
    textTheme: TextTheme(overline: TextStyle(color: Colors.white),),
    iconTheme: IconThemeData(color: Colors.white)
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.cyan,
    foregroundColor: Colors.white,
    elevation: 2.0, 
  ),
  primaryIconTheme: IconThemeData(color: Colors.cyan),
  primaryTextTheme: TextTheme(caption: TextStyle(color: Colors.white))
);
