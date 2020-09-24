import 'package:flutter/material.dart';

const List resourceHelper = [
  'resources/front.svg',
  'resources/bottom.svg',
  'resources/profile.png',
  'resources/back.png',
];

const List colors = [
  Colors.deepPurple,
  Colors.deepOrange,
  Colors.amber,
  Colors.lightBlue,
  Colors.lightGreen,
  Colors.grey,
  Colors.white,
  Colors.black,
];

const kFirstText = 'Make your E-learning easy with';
const kSL = 'SmartLearn ';
const kOTP = ' Check your email for OTP ';

snack(c, txt) {
  return Scaffold.of(c).showSnackBar(
    SnackBar(
      content: Text(
        txt,
      ),
    ),
  );
}

drawer() {
  return Drawer(
    child: Column(
      children: [
        ListTile(
          leading: Icon(Icons.home),
          title: Text('Home'),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.local_library),
          title: Text('Library'),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.playlist_add),
          title: Text('ToDo'),
          onTap: () {},
        ),
      ],
    ),
  );
}
