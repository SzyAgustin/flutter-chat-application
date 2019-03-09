import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import './screens/button_screen.dart';

final ThemeData iOSTheme = ThemeData(
  primarySwatch: Colors.red,
  primaryColor: Colors.grey[400],
  primaryColorBrightness: Brightness.dark,
);

final ThemeData androidTheme = ThemeData(
  primarySwatch: Colors.blue,
  accentColor: Colors.blue,
);

const String defaultUserName = "Agustin Szyszczyc";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    return MaterialApp(
      title: "Chat Application",
      theme:
          defaultTargetPlatform == TargetPlatform.iOS ? iOSTheme : androidTheme,
      home: ButtonScreen(),
    );
  }
}




