import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../helper.dart';
import 'auth_net.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class DataAllClasses extends ChangeNotifier {
  List myclasses = [];
  List mytodo = [];
  List assign = [];
  List ans = [];
  List ans1 = [];
  List filterL = [];
  List mydis = [];
  List allgrd = [];
  List grades = [];
  List notifications = [];
  bool newNoti = false;
  logOut() {
    myclasses.clear();
    mytodo.clear();
    filterL.clear();
    notifications.clear();
    newNoti = false;
    notifyListeners();
  }

  filter(int chipIndex) {
    if (ans.isNotEmpty || ans1.isNotEmpty) {
      switch (chipIndex) {
        case 1:
          filterL.clear();
          filterL = ans.toList();
          break;
        case 2:
          filterL.clear();
          filterL = ans1.toList();
          break;
        case 3:
          filterL.clear();
          filterL = ans.toList();
          filterL.addAll(ans1.toList());
          break;
        case 4:
          filterL.clear();
          filterL = ans.where((element) => element[4]).toList();
          break;
        case 5:
          filterL.clear();
          filterL = ans.where((element) => !element[4]).toList();
          break;
        case 6:
          filterL.clear();
          filterL = ans.where((element) => !element[5]).toList();
          break;
        case 7:
          filterL.clear();
          filterL = ans.where((element) => element[5]).toList();
          break;
      }
      if (chipIndex == 7)
        filterL.sort((a, b) => b[3].compareTo(a[3]));
      else
        filterL.sort((a, b) =>
            a.toString().toLowerCase().compareTo(b.toString().toLowerCase()));
      notifyListeners();
    }
  }

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
        notifications.insert(0, [sub, des, DateTime.now()]);
        newNoti = true;
        notifyListeners();
        if (res == 200) return res;
      }
      return response.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }

  Future<int> deleteClass(BuildContext context, int classID) async {
    try {
      var response = await http.delete(
        kurl + '/class/classroom/$classID/',
        headers: {
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<Auth>(context, listen: false).token}',
        },
      );
      print(response.statusCode);
      if (response.statusCode == 204) {
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
        final responseData = json.decode(response.body);
        notifications.insert(0, [
          responseData["subject_name"],
          responseData["description"],
          DateTime.now()
        ]);
        newNoti = true;
        notifyListeners();
        final res = await updateClass(context);
        if (res == 200) return res;
      }
      return response.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }

  Future<int> updateAssign(BuildContext context, classID) async {
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
          return 0;
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
      maxMarks, File file) async {
    try {
      var response;
      if (file != null) {
        String fileName = basename(file.path);
        final mimeTypeData = lookupMimeType(file.path).split("/");
        FormData formData = FormData.fromMap({
          "title": "$title",
          "description": "$des",
          "submit_by": "$time",
          "max_marks": "$maxMarks",
          "file_linked": await MultipartFile.fromFile(file.path,
              filename: fileName,
              contentType: MediaType(mimeTypeData[0], mimeTypeData[1])),
        });
        response = await Dio().post(
          kurl + '/class/classroom/$classID/assignment/',
          data: formData,
          options: Options(
            headers: {
              'Authorization':
                  'Bearer ${Provider.of<Auth>(context, listen: false).token}',
            },
          ),
        );
      } else {
        response = await http.post(
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
            },
          ),
        );
      }

      print(response.statusCode);
      if (response.statusCode == 201) {
        updateAssign(context, classID);
      }
      if (response.statusCode == 403) {
        print('Don\'t mess with my code!!');
      }
      return response.statusCode;
    } catch (error) {
      print(error);
      if (error.toString().substring(53, 56) == 400.toString()) return 400;
      return -1;
    }
  }

  Future<int> deleteAssign(BuildContext context, int classID, int assID) async {
    try {
      var response = await http.delete(
        kurl + '/class/classroom/$classID/assignment/$assID/',
        headers: {
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<Auth>(context, listen: false).token}',
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        return updateAssign(context, classID);
      }
      return response.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }

  Future viewAllAss(BuildContext context, classID, assID, chipIndex) async {
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
        responseData["answers"].forEach((ansNum) {
          ans.add([
            ansNum["student"]["name"],
            ansNum["student"]["picture"],
            ansNum["file_linked"],
            ansNum["marks_scored"],
            ansNum["late_submitted"],
            ansNum["checked"],
            ansNum["id"],
          ]);
        });
        ans1.clear();
        responseData["not_submitted"].forEach((ansNum) {
          ans1.add([
            ansNum["name"],
            ansNum["picture"],
            ansNum["id"],
          ]);
        });
        filter(chipIndex);
        notifyListeners();
      }
      return response.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }

  Future<int> updateMarks(
      BuildContext context, marks, classID, assID, ansID, chipIndex) async {
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
        viewAllAss(context, classID, assID, chipIndex);
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
      print(response.body);
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

  Future uploadAns(BuildContext context, classID, assID, File file) async {
    try {
      String fileName = basename(file.path);
      final mimeTypeData = lookupMimeType(file.path).split("/");
      FormData formData = FormData.fromMap({
        "file_linked": await MultipartFile.fromFile(file.path,
            filename: fileName,
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1])),
      });
      final response = await Dio().post(
        kurl + '/class/classroom/$classID/assignment/$assID/answer/',
        data: formData,
        options: Options(
          headers: {
            'Authorization':
                'Bearer ${Provider.of<Auth>(context, listen: false).token}',
          },
        ),
      );
      print(response.statusCode);
      if (response.statusCode == 201) {
        updateAssign(context, classID);
        final res = await viewAns(context, classID, assID, response.data["id"]);
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

  Future allGrades(BuildContext context, int classID) async {
    try {
      var response = await http.get(
        kurl + '/class/classroom/$classID/portal/teacher/',
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
          print('no students');
          return;
        }
        allgrd.clear();
        responseData.forEach((grdNum) {
          allgrd.add([
            grdNum["student"]["name"],
            grdNum["percentage"],
            grdNum["student"]["picture"],
            grdNum["student"]["id"],
          ]);
        });
        allgrd.sort((a, b) =>
            a.toString().toLowerCase().compareTo(b.toString().toLowerCase()));
        notifyListeners();
      }
      return response.statusCode;
    } catch (error) {
      print(error);
      return -1;
    }
  }

  Future grade(BuildContext context, int classID, int stdID) async {
    try {
      var response = await http.get(
        kurl + '/class/classroom/$classID/portal/$stdID/',
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
          print('impossible');
          return;
        }
        grades.clear();
        grades.add(responseData["percentage"]);
        responseData["assignments"].forEach((grdNum) {
          grades.add([
            grdNum["assignment"],
            grdNum["max_marks"],
            grdNum["submitted"],
            grdNum["checked"],
            grdNum["marks_scored"],
            grdNum["due_date"],
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
}
