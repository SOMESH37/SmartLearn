import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

var kurl = "https://47db6908f33e.ngrok.io";
var _pwd, _id, _atoken;
bool isAuth = false;

class Auth with ChangeNotifier {
  static Future<int> sign(name, email, pwd, img) async {
    try {
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
      print(responseS.statusCode);
      return responseS.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
    _pwd = pwd;
  }

  static Future<int> otpS(email, otp, bool isT) async {
    try {
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
      print(responseOS.statusCode);
      if (responseOS.statusCode == 200) login(email, _pwd);
      return responseOS.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }

  static Future<int> otpfPwd(email) async {
    try {
      var responsefPwd = await http.post(
        kurl + '/api/password/reset',
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(
          {
            "email": "$email",
          },
        ),
      );
      print(responsefPwd.statusCode);
      if (responsefPwd.statusCode == 200) {
        final responseData = json.decode(responsefPwd.body);
        _id = responseData['id'];
      }
      return responsefPwd.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }

  static Future<int> fPwd(email, otp) async {
    try {
      var response = await http.post(
        kurl + '/api/password/reset/verify',
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(
          {
            "email": "$email",
            "otp": "$otp",
          },
        ),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _atoken = responseData['access'];
        print(_atoken);
      }
      return response.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }

  static Future changePwd(pwd) async {
    try {
      var response = await http.put(
        kurl + '/api/users/$_id/',
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_atoken',
        },
        body: {
          "password": "$pwd",
        },
      );
      print(response.statusCode);
      return response.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }

  static Future<int> login(email, pwd) async {
    try {
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
      return responseL.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }

  static Future tokenRequest(token) async {
    var responseTR = await http.post(
      kurl + '/api/login/refresh/',
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(
        {
          "refresh": "$token",
        },
      ),
    );
    print(responseTR.body);
  }

  static Future tokenAccess() async {
    var response = await http.put(kurl + '/api/users/$_id/', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_atoken',
    }, body: {
      "password": "",
    });
  }
}
