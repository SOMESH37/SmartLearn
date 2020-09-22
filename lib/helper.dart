import 'package:flutter/material.dart';

const List resourceHelper = [
  'resources/front.svg',
  'resources/bottom.svg',
  'resources/profile.png',
];

const kFirstText = 'Make your E-learning easy with';
const kSL = ' SmartLearn ';
const kOTP = ' Check your email for OTP ';

Snack(c, txt) {
  return Scaffold.of(c).showSnackBar(
    SnackBar(
      content: Text(
        txt,
      ),
    ),
  );
}
