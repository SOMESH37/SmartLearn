import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:smartlearn/helper.dart';
import 'dart:convert';

var kurl = "https://b363a4a06abe.ngrok.io";
var _pwd;
var _email;
bool isAuth = false;

class Auth with ChangeNotifier {
  static Future sign(name, email, pwd, img) async {
    var responseS = await http.post(
      kurl + '/api/users/',
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(
        {
          "email": "$email",
          "password": "$pwd",
          "profile": {
            "name": "$name",
            "picture": img == null ? null : "$img",
          }
        },
      ),
    );
    if (responseS.statusCode > 220) {
      HapticFeedback.vibrate();
      Builder(
        builder: (context) =>
            snack(context, 'Email exist-${responseS.statusCode}'),
      );
    }
    _pwd = pwd;
    _email = email;
    print(responseS.body);
    return responseS.statusCode;
  }

  static Future otpS(email, otp, bool isT) async {
    var responseOS = await http.post(
      kurl + '/api/verify/',
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(
        {
          "email": "$email",
          "otp": "$otp",
          "is_teacher": isT,
        },
      ),
    );
    print(responseOS.body);
    if (responseOS.statusCode > 300) {
      HapticFeedback.vibrate();
      Builder(
        builder: (context) =>
            snack(context, 'Wrong OTP-${responseOS.statusCode}'),
      );
    } else {
      login(_email, _pwd);
      Builder(
        builder: (context) => snack(context, 'Setting you up hold up!'),
      );
    }
  }

  static Future login(email, pwd) async {
    var responseL = await http.post(
      kurl + '/api/login/',
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(
        {
          "email": "$email",
          "password": "$pwd",
        },
      ),
    );

    print(responseL.body);
    if (responseL.statusCode > 300) {
      Builder(
        builder: (context) => snack(context, 'BAD${responseL.statusCode}'),
      );
    }
    return responseL.statusCode;
  }

  static Future token(email, pwd) async {
    var responseT = await http.post(
      kurl + '/users/login/',
      body: json.encode(
        {
          "email": email,
          "password": pwd,
        },
      ),
    );
  }
}
