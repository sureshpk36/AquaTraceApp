import 'package:flutter/material.dart';
import 'package:aquatraceapp/login_screen.dart';

void main() {
  runApp(AquaTraceApp());
}

class AquaTraceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AquaTrace App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}
