import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../helper.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';

var _pwd, _id, _atoken, _rtoken;
Timer autoRefresh;
String rTOKEN;
List pro = [];
var pref;

class Auth extends ChangeNotifier {
  List data = [];
  String token;
  bool isAuth = false;
  Future<int> sign(name, email, pwd, File img) async {
    try {
      if (img != null) {
        String fileName = basename(img.path);
        final mimeTypeData = lookupMimeType(img.path).split("/");
        FormData formData = FormData.fromMap({
          "email": "$email",
          "password": "$pwd",
          "profile.name": "$name",
          "profile.picture": await MultipartFile.fromFile(img.path,
              filename: fileName,
              contentType: MediaType(mimeTypeData[0], mimeTypeData[1])),
        });
        final response = await Dio().post(
          kurl + '/api/users/',
          data: formData,
          // options: Options(
          // responseType: ResponseType.json,
          // headers: {
          //   "Content-Type": "application/json",
          // },
          //     ),
        );
        _pwd = pwd;
        return response.statusCode;
      }

      // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>201>>>>226>>>>>

      if (img == null) {
        final response = await http.post(
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
                "picture": null,
              }
            },
          ),
        );
        _pwd = pwd;
        return response.statusCode;
      }
    } catch (error) {
      print(error);
      return -1;
    }
  }

  Future<int> otpS(email, otp, bool isT) async {
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
      print(responseOS.body);
      if (responseOS.statusCode == 202) {
        return login(email, _pwd);
      } else
        return responseOS.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }

  Future<int> otpfPwd(email) async {
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
      print(responsefPwd.body);
      if (responsefPwd.statusCode == 200) {
        final responseData = json.decode(responsefPwd.body);
        _id = responseData['id'];
      } else if (responsefPwd.statusCode == 308) {
        print(responsefPwd.body);
      }
      return responsefPwd.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }

  Future<int> fPwd(email, otp) async {
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
      print(response.body);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _atoken = responseData["access"];
        _rtoken = responseData["refresh"];
        this.token = _atoken;
        rTOKEN = _rtoken;
      }

      return response.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }

  Future<int> changePwd(pwd) async {
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
      print(response.body);
      if (response.statusCode == 202) {
        final responseData = json.decode(response.body);
        List profile = [
          responseData["name"],
          responseData["email"],
          !responseData["is_teacher"],
          responseData["picture"],
        ];
        data.clear();
        data.add(profile);
        isAuth = true;
        notifyListeners();
        tokenRefresh(_rtoken);
        if (pref != null) pref.clear();
        pref = await SharedPreferences.getInstance();
        final userData = json.encode(
          {
            "refresh": rTOKEN,
            "name": responseData["name"],
            "email": responseData["email"],
            "is_teacher": !responseData["is_teacher"],
            "picture": responseData["picture"],
          },
        );
        pref.setString("userData", userData);
      }
      return response.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }

  Future<int> login(email, pwd) async {
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
      print(responseL.statusCode);
      print(responseL.body);
      if (responseL.statusCode == 200) {
        final responseData = json.decode(responseL.body);
        _atoken = responseData["access"];
        _rtoken = responseData["refresh"];
        List profile = [
          responseData["name"],
          responseData["email"],
          !responseData["is_teacher"],
          responseData["picture"],
        ];
        this.token = _atoken;
        data.clear();
        data.add(profile);
        isAuth = true;
        notifyListeners();
        if (autoRefresh != null) autoRefresh.cancel();
        autoRefresh = Timer(
          Duration(minutes: 19),
          () => tokenRefresh(_rtoken),
        );
        rTOKEN = _rtoken;
        if (pref != null) pref.clear();
        pref = await SharedPreferences.getInstance();
        final userData = json.encode(
          {
            "refresh": rTOKEN,
            "name": responseData["name"],
            "email": responseData["email"],
            "is_teacher": !responseData["is_teacher"],
            "picture": responseData["picture"],
          },
        );
        pref.setString("userData", userData);
        print(pref);
      }
      return responseL.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }

  Future<void> tokenRefresh(toke) async {
    try {
      var responseTR = await http.post(
        kurl + '/api/login/refresh/',
        body: {
          "refresh": "$toke",
        },
      );
      print(responseTR.statusCode);
      if (responseTR.statusCode == 200) {
        final responseData = json.decode(responseTR.body);
        _atoken = responseData["access"];
        this.token = _atoken;
        notifyListeners();
        print(token);
        if (autoRefresh != null) autoRefresh.cancel();
        autoRefresh = Timer(
          Duration(minutes: 19),
          () => tokenRefresh(_rtoken),
        );
      } else if (responseTR.statusCode == 401) {
        this.token = null;
        isAuth = false;
        notifyListeners();
      } else {
        tokenRefresh(_rtoken);
      }
    } catch (error) {
      print(error);
      tokenRefresh(_rtoken);
      print('Token can\'t be refreshed!');
    }
  }

  Future<int> resendOTP(email) async {
    try {
      var response = await http.post(
        kurl + '/api/otp/resend/',
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(
          {
            "email": "$email",
          },
        ),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 202) {}
      return response.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }
    return true;
    final extractedUserData = json.decode(prefs.getString("userData"));
    print(extractedUserData);
    final tok = extractedUserData["refresh"];
    tokenRefresh(tok);
    data[0] = extractedUserData["name"];
    data[1] = extractedUserData["email"];
    data[2] = extractedUserData["is_teacher"];
    data[3] = extractedUserData["picture"];
    this.isAuth = true;
    notifyListeners();
  }
}
