import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../helper.dart';
import 'auth_net.dart';
import 'package:provider/provider.dart';

class DataAllClasses extends ChangeNotifier {
  List myclasses = [];
  List mytodo = [];
  Future updateClass(BuildContext context) async {
    try {
      var response = await http.get(
        kurl + '/class/classroom/',
        headers: {
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<Auth>(context, listen: false).token}',
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
        notifyListeners();
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
        notifyListeners();
        print(responseData);
      }
      return response.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }

  Future joinClass(BuildContext context, String code) async {
    try {
      var response = await http.post(
        kurl + '/class/join/',
        headers: {
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<Auth>(context, listen: false).token}',
          'Content-Type': 'application/json',
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
        updateClass(context);
        notifyListeners();
      }
      return response.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }

  Future<int> updateTodo(BuildContext context) async {
    try {
      var response = await http.get(
        kurl + '/todo/',
        headers: {
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<Auth>(context, listen: false).token}',
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData == null) {
          print('no todo');
          return (response.statusCode);
        }
        mytodo.clear();
        responseData.forEach((todoNum) {
          mytodo.add([
            todoNum["id"],
            todoNum["title"],
            todoNum["description"],
          ]);
        });
        notifyListeners();
        print(mytodo);
        return (response.statusCode);
      }
      return response.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }

  Future createTodo(BuildContext context, String title, String des) async {
    try {
      var response = await http.post(
        kurl + '/todo/',
        headers: {
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<Auth>(context, listen: false).token}',
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {"title": "$title", "description": "$des"},
        ),
      );
      print(response.statusCode);
      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        mytodo.add([
          responseData["id"],
          responseData["title"],
          responseData["description"],
        ]);
        notifyListeners();
        print(mytodo);
      }
      return response.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }

  Future<int> deleteTodo(BuildContext context, int id) async {
    try {
      var response = await http.delete(
        kurl + '/todo/$id/',
        headers: {
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<Auth>(context, listen: false).token}',
        },
      );
      print(response.statusCode);
      if (response.statusCode == 204) {
        print('Deleted todo');
        return updateTodo(context);
      }
      return response.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }
}
