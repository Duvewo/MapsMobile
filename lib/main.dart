import 'package:flutter/material.dart';

/* pages */
import 'pages/auth.dart';
import 'pages/home.dart';
import 'pages/about.dart';
import 'pages/donate.dart';
import 'pages/help.dart';

void main() {
  runApp(new MaterialApp(
    initialRoute: "/",
    routes: {
      "/auth": (context) => AuthPageClass(),
      "/": (context) => HomePageClass(),
      "/help": (context) => HelpPageClass(),
      "/donate": (context) => DonatePageClass(),
      "/about": (context) => AboutPageClass(),
    },
  ));
}
