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
    return ChangeNotifierProvider<Auth>(
      create: (context) => Auth(),
      builder: (context, _) {
        return MaterialApp(
          theme: ThemeData(
            fontFamily: 'Gilroy',
          ),
          home: Provider.of<Auth>(context).isAuth ? Home() : First(),
        );
      },
    );
  }
}
