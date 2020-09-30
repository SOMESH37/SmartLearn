import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../helper.dart';
import 'auth_net.dart';
import 'package:provider/provider.dart';

class DataClass with ChangeNotifier {
  String id;
  String subject;
  String description;
  String teacher;
  String img;

  DataClass({
    this.id,
    this.subject,
    this.description,
    this.teacher,
    this.img,
  });
}

class DataAllClasses extends ChangeNotifier {
  String id;
  String subject;
  String description;
  String teacher;
  String img;

  List myclass = [];
  Future<int> updateClass() async {
    try {
      var response = await http.get(
        kurl + '/class/classroom/',
        headers: {
          'Accept': 'application/json',
          // 'Authorization': 'Bearer ${Auth.token}',
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(response.body);
        print(responseData);
        List loaded = [];
      }
      return response.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }
}
