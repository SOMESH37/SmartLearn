import 'package:flutter/gestures.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import '../helper.dart';
import 'package:flutter_svg/flutter_svg.dart';

var gapH;
var gapW;
File pickedImage;
var type = 0;
var high = AppBar().preferredSize.height;
var svgPicture = SvgPicture.asset(
  resourceHelper[1],
  alignment: Alignment.bottomCenter,
  width: gapW,
);

class First extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => Front(),
        '/signup': (context) => SignUp(),
        '/otp': (context) => Otp(),
        '/login': (context) => Login(),
        '/changepwd': (context) => ChangePwd(),
      },
      initialRoute: '/',
    );
  }
}

class Front extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    gapH = deviceSize.height;
    gapW = deviceSize.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: gapH,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SvgPicture.asset(
                resourceHelper[0],
                height: gapH * 0.3,
                alignment: Alignment.topCenter,
              ),
              Divider(
                color: Colors.green,
                thickness: 2,
                height: gapH * 0.1,
                endIndent: gapW * 0.35,
                indent: gapW * 0.35,
              ),
              Text(
                kFirstText,
              ),
              Text(
                kSL,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(
                height: gapH * 0.04,
              ),
              FlatButton(
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: Text(
                  'Create account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                  //side: BorderSide(color: Colors.red),
                ),
              ),
              SizedBox(
                height: gapH * 0.02,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'or',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: ' Login',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              svgPicture,
            ],
          ),
        ),
      ),
    );
  }
}

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _autoval = false;
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: gapH,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: gapW * 0.9,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final pickedImageFile = await ImagePicker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 50,
                          maxWidth: 150,
                        );
                        setState(() {
                          pickedImage = pickedImageFile;
                        });
                      },
                      child: Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            backgroundImage: pickedImage == null
                                ? AssetImage(resourceHelper[2])
                                : FileImage(pickedImage),
                          ),
                          CircleAvatar(
                            maxRadius: 15,
                            backgroundColor: Colors.grey[300],
                            child: Icon(
                              Icons.edit,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: gapH * 0.06,
                    ),
                    Form(
                      key: _formKey,
                      autovalidate: _autoval,
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.portrait,
                              ),
                              labelText: 'Full name',
                              labelStyle: TextStyle(
                                  color: Colors.grey[400], fontSize: 12),
                            ),
                            validator: validateName,
                            onSaved: (value) {},
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              icon: Icon(Icons.email),
                              labelText: 'Email address',
                              labelStyle: TextStyle(
                                  color: Colors.grey[400], fontSize: 12),
                            ),
                            validator: validateEmail,
                            onSaved: (value) {},
                          ),
                          TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              icon: Icon(Icons.lock),
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                  color: Colors.grey[400], fontSize: 12),
                            ),
                            obscureText: true,
                            controller: _passwordController,
                            validator: validatePwd,
                            onSaved: (value) {},
                          ),
                          TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              icon: Icon(Icons.lock),
                              labelText: 'Confirm password',
                              labelStyle: TextStyle(
                                  color: Colors.grey[400], fontSize: 12),
                            ),
                            obscureText: true,
                            autovalidate: true,
                            validator: (value) =>
                                (value != _passwordController.text)
                                    ? 'Passwords do not match!'
                                    : null,
                            onSaved: (value) {},
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: gapH * 0.03,
              ),
              FlatButton(
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                onPressed: () {
                  if (!_formKey.currentState.validate()) {
                    setState(() {
                      _autoval = true;
                    });

                    return;
                  }
                  type = 1;
                  Navigator.pushNamed(context, '/otp');
                },
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
                height: gapH * 0.05,
                endIndent: gapW * 0.4,
                indent: gapW * 0.4,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Already have a account?',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacementNamed(context, '/login');
                          // HapticFeedback.vibrate();
                        },
                      text: ' Login',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              svgPicture,
            ],
          ),
        ),
      ),
    );
  }
}

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: gapH,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: gapW * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        icon: Icon(Icons.email),
                        labelText: 'Email address',
                        labelStyle:
                            TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                      onSaved: (value) {},
                      validator: validateEmail,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        labelText: 'Password',
                        labelStyle:
                            TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                      obscureText: true,
                      onSaved: (value) {},
                    ),
                    SizedBox(
                      height: gapH * 0.07,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            type = 2;
                            Navigator.pushNamed(context, '/otp');
                          },
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        SizedBox(
                          width: gapW * 0.3,
                        ),
                        FlatButton(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                          ),
                          onPressed: () {
                            //login
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                            //side: BorderSide(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
                height: gapH * 0.1,
                endIndent: gapW * 0.3,
                indent: gapW * 0.3,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'New user?',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacementNamed(context, '/signup');
                        },
                      text: ' Sign Up',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              svgPicture,
            ],
          ),
        ),
      ),
    );
  }
}

class Otp extends StatefulWidget {
  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  var txt = 'Confirm OTP';
  var btext = 'Reset password';
  bool isStu = true;

  @override
  Widget build(BuildContext context) {
    if (type == 1) {
      txt = 'Confirm your E-mail';
      btext = 'Create account';
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: gapH - high,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                txt,
                style: TextStyle(color: Colors.grey, fontSize: 20),
              ),
              SizedBox(
                height: gapH * 0.15,
              ),
              Container(
                width: gapW * 0.7,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.vpn_key,
                    ),
                    labelText: kOTP,
                    labelStyle:
                        TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                  onSaved: (value) {},
                ),
              ),
              SizedBox(
                height: gapH * 0.05,
              ),
              (type == 1)
                  ? Column(
                      children: [
                        Text(
                          'Please choose your role',
                          style: TextStyle(
                            //letterSpacing: 1.5,
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ChoiceChip(
                              selectedColor: Colors.blue[200],
                              padding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 10,
                              ),
                              label: Text(
                                'Student',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: colors[7],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              selected: isStu,
                              onSelected: (p) {
                                setState(() {
                                  isStu = p;
                                  print('object');
                                });
                              },
                            ),
                            SizedBox(
                              width: gapW * 0.04,
                            ),
                            ChoiceChip(
                              selectedColor: Colors.blue[200],
                              padding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 10,
                              ),
                              label: Text(
                                'Teacher',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: colors[7],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              selected: !isStu,
                              onSelected: (p) {
                                setState(() {
                                  isStu = !p;
                                  print('teacher');
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: gapH * 0.05,
                        ),
                      ],
                    )
                  : SizedBox(
                      height: gapH * 0.05,
                    ),
              FlatButton(
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                onPressed: () {
                  if (type == 1)

                    //SIGN UP

                    ;
                  else {
                    Navigator.pushNamed(context, '/changepwd');
                  }
                },
                child: Text(
                  btext,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              svgPicture,
            ],
          ),
        ),
      ),
    );
  }
}

class ChangePwd extends StatefulWidget {
  @override
  _ChangePwdState createState() => _ChangePwdState();
}

class _ChangePwdState extends State<ChangePwd> {
  final _passwordControl = TextEditingController();
  final _passwordControl2 = TextEditingController();
  bool _autoval = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: gapH - high,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Set new password',
                style: TextStyle(color: Colors.grey, fontSize: 20),
              ),
              SizedBox(
                height: gapH * 0.12,
              ),
              Container(
                width: gapW * 0.9,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        labelText: 'Password',
                        labelStyle:
                            TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                      obscureText: true,
                      validator: validatePwd,
                      autovalidate: _autoval,
                      controller: _passwordControl,
                      onSaved: (value) {},
                    ),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        labelText: 'Confirm password',
                        labelStyle:
                            TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                      obscureText: true,
                      controller: _passwordControl2,
                      autovalidate: _autoval,
                      validator: (value) => (value != _passwordControl.text)
                          ? 'Passwords do not match!'
                          : null,
                      onSaved: (value) {},
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: gapH * 0.1,
              ),
              FlatButton(
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                onPressed: () {
                  if (_passwordControl.text != _passwordControl2.text ||
                      _passwordControl.text.length < 5 ||
                      _passwordControl.text.length > 10) {
                    setState(() {
                      _autoval = true;
                    });

                    return;
                  }

                  //LOGIN RESET
                },
                child: Text(
                  'Reset password',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              svgPicture,
            ],
          ),
        ),
      ),
    );
  }
}

String validateName(value) {
  if (value.length < 2 || value.length > 14)
    return 'Weird Name';
  else
    return null;
}

String validatePwd(value) {
  if (value.length < 5)
    return 'Password is too short!';
  else if (value.length > 10)
    return 'Password is too long!';
  else
    return null;
}

String validateEmail(value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp _regex = new RegExp(pattern);
  if (!_regex.hasMatch(value))
    return 'Enter valid email';
  else
    return null;
}
