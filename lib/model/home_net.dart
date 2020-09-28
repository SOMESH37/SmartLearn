import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import '../helper.dart';
import 'auth_net.dart';

class DataAllClasses extends ChangeNotifier {
  BuildContext context;
  //var tok = Provider.of<Auth>(context).isAuth;
  Future<int> classes() async {
    try {
      var response = await http.get(
        kurl + '/class/classroom/',
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ',
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) ;
      return response.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }
}
