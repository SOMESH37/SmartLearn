import 'package:dio/dio.dart';
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
  List assign = [];
  List ans = [];
  List mydis = [];
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
      print(response.body);
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
            classNum["class_code"],
            classNum["id"],
            classNum["student_no"],
          ]);
        });
        notifyListeners();
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
        final res = await updateClass(context);
        if (res == 200) return res;
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
        final res = await updateClass(context);
        if (res == 200) return res;
      }
      return response.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }

  Future updateAssign(BuildContext context, classID) async {
    try {
      var response = await http.get(
        kurl + '/class/classroom/$classID/assignment/',
        headers: {
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<Auth>(context, listen: false).token}',
        },
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData == null) {
          print('no assignments');
          return;
        }
        assign.clear();
        responseData.forEach((assignNum) {
          assign.add([
            assignNum["id"],
            assignNum["title"],
            assignNum["description"],
            assignNum["submit_by"],
            assignNum["max_marks"],
            assignNum["file_linked"],
            assignNum["answer_id"],
          ]);
        });
        notifyListeners();
      }
      return response.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }

  Future<int> createAssign(BuildContext context, int classID, title, des, time,
      maxMarks, file) async {
    try {
      var response = await http.post(
        kurl + '/class/classroom/$classID/assignment/',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<Auth>(context, listen: false).token}',
        },
        body: json.encode(
          {
            "title": "$title",
            "description": "$des",
            "submit_by": "$time",
            "max_marks": "$maxMarks",
            "file_linked": file == null ? null : file,
          },
        ),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 201) {
        updateAssign(context, classID);
      }
      if (response.statusCode == 403) {
        print('Don\'t mess with my code!!');
      }
      return response.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }

  Future viewAllAss(BuildContext context, classID, assID) async {
    try {
      var response = await http.get(
        kurl + '/class/classroom/$classID/assignment/$assID/answers/',
        headers: {
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<Auth>(context, listen: false).token}',
        },
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 202) {
        final responseData = json.decode(response.body);
        if (responseData == null) {
          print('no ans');
          return;
        }
        ans.clear();
        responseData.forEach((ansNum) {
          ans.add([
            ansNum["id"],
            ansNum["file_linked"],
            ansNum["marks_scored"],
            ansNum["late_submitted"],
            ansNum["checked"],
            ansNum["student"]["name"],
            ansNum["student"]["picture"],
          ]);
        });

        notifyListeners();
      }
      return response.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }

  Future<int> updateMarks(
      BuildContext context, marks, classID, assID, ansID) async {
    try {
      var response = await http.put(
        kurl + '/class/classroom/$classID/assignment/$assID/answer/$ansID/',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<Auth>(context, listen: false).token}',
        },
        body: json.encode(
          {
            "marks_scored": "$marks",
          },
        ),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        viewAllAss(context, classID, assID);
      }
      return response.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }

  Future viewAns(BuildContext context, classID, assID, int ansID) async {
    try {
      var response = await http.get(
        kurl + '/class/classroom/$classID/assignment/$assID/answer/$ansID/',
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
          print('impossible');
          return;
        }
        ans.clear();
        ans.add([
          responseData["id"],
          responseData["file_linked"],
          responseData["marks_scored"],
          responseData["late_submitted"],
          responseData["checked"],
        ]);

        notifyListeners();
      }
      return response.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }

  Future uploadAns(BuildContext context, classID, assID, file) async {
    try {
      var response = await http.post(
        kurl + '/class/classroom/$classID/assignment/$assID/answer/',
        headers: {
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<Auth>(context, listen: false).token}',
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            "file_linked": file,
          },
        ),
      );
      print(response.statusCode);
      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        updateAssign(context, classID);
        final res = await viewAns(context, classID, assID, responseData["id"]);
        if (res == 200) return res;
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
        print(response.body);
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
          {
            "title": "$title",
            "description": des == null ? null : "$des",
          },
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
        return updateTodo(context);
      }
      return response.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }

  Future updateDiscuss(BuildContext context, int classID) async {
    try {
      var response = await http.get(
        kurl + '/class/classroom/$classID/doubt/',
        headers: {
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<Auth>(context, listen: false).token}',
        },
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData == null) {
          print('no doubt');
          return;
        }
        mydis.clear();
        responseData.forEach((disNum) {
          mydis.add([
            disNum["time_created"],
            disNum["doubt_text"],
            disNum["user"]["name"],
            disNum["user"]["picture"],
            disNum["id"],
            disNum["doubt_sender"]
          ]);
        });
        notifyListeners();
      }
      return response.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }

  Future<int> discuss(BuildContext context, String dis, int classID) async {
    try {
      var response = await http.post(
        kurl + '/class/classroom/$classID/doubt/',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<Auth>(context, listen: false).token}',
        },
        body: json.encode(
          {
            "doubt_text": "$dis",
          },
        ),
      );
      print(response.statusCode);
      if (response.statusCode == 201) {
        int res = await updateDiscuss(context, classID);
        if (res == 200) return res;
      }
      return response.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }

  Future<int> deleteDiscuss(
      BuildContext context, int classID, int disID) async {
    try {
      var response = await http.delete(
        kurl + '/class/classroom/$classID/doubt/$disID/',
        headers: {
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<Auth>(context, listen: false).token}',
        },
      );
      print(response.statusCode);
      if (response.statusCode == 202) {
        int res = await updateDiscuss(context, classID);
        if (res == 200) return res;
      }
      return response.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }
}
