import 'package:flutter/material.dart';
import 'package:smartlearn/model/home_net.dart';
import './screens/authentication.dart';
import './screens/home.dart';
import './model/auth_net.dart';
import 'package:provider/provider.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (_) => DataAllClasses(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) {
          return MaterialApp(
            theme: ThemeData(
              fontFamily: 'Gilroy',
            ),
            routes: {
              // '/': (context) => Front(),
              '/signup': (context) => SignUp(),
              '/otp': (context) => Otp(),
              '/login': (context) => Login(),
              '/changepwd': (context) => ChangePwd(),
            },
            home: auth.isAuth
                ? Home()
                :
                // First()

                FutureBuilder(
                    future: auth.autoLogin(),
                    builder: (context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : First(),
                  ),
          );
        },
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Will create it soon!'),
    );
  }
}
