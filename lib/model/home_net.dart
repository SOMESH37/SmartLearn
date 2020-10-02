import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../helper.dart';
import 'auth_net.dart';
import 'package:provider/provider.dart';

class DataAllClasses extends ChangeNotifier {
  List myclasses = [];
  Future updateClass(BuildContext context) async {
    //print(Provider.of<Auth>(context).token);
    try {
      var response = await http.get(
        kurl + '/class/classroom/',
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Provider.of<Auth>(context).token}',
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData == null) {
          print('no classes');
          return;
        }
        myclasses.clear();
        responseData.forEach((classNum) {
          myclasses.add([
            classNum["subject_name"],
            classNum["description"],
            classNum["teacher"]["name"],
            classNum["teacher"]["picture"],
          ]);
        });
        print(myclasses);
      }
      return response.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }

  Future<int> createClass(BuildContext context, String sub, String des) async {
    try {
      var response = await http.post(
        kurl + '/class/classroom/',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<Auth>(context, listen: false).token}',
        },
        body: json.encode(
          {
            "subject_name": "$sub",
            "description": "$des",
          },
        ),
      );
      print(response.statusCode);
      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        myclasses.add([
          responseData["subject_name"],
          responseData["description"],
          responseData["teacher"]["name"],
          responseData["teacher"]["picture"],
        ]);
        print(responseData);
      }
      return response.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }
}

Future joinClass(BuildContext context, String code) async {
  try {
    var response = await http.post(
      kurl + '/class/join/',
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Provider.of<Auth>(context).token}',
      },
      body: json.encode(
        {
          "class_code": "$code",
        },
      ),
    );
    print(response.statusCode);
    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      print(responseData);
      List loaded = [];
    }
    return response.statusCode;
  } catch (error) {
    print(error);
    return -1;
  }
}
