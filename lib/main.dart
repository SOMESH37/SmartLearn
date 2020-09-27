import 'package:flutter/material.dart';
import './screens/authentication.dart';
import './screens/home.dart';
import './model/auth_net.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData.dark(),
      home: isAuth ? Home() : First(),
    );
  }
}
