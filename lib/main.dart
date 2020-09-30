import 'package:flutter/material.dart';
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
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) {
          return MaterialApp(
            theme: ThemeData(
              fontFamily: 'Gilroy',
            ),
            home: AnimatedSplashScreen(
              splash: 'resources/logo.png',
              splashIconSize: 300,
              splashTransition: SplashTransition.fadeTransition,
              animationDuration: Duration(milliseconds: 100),
              nextScreen: Provider.of<Auth>(context).isAuth
                  ? Home()
                  : auth.token == -1 ? Login() : First(),
            ),
          );
        },
      ),
    );
  }
}
