import 'package:flutter/gestures.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import '../helper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home.dart';
import '../model/auth_net.dart';

var gapH, gapW, email, pwd;
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
  var name;
  bool isLoad = false;
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
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.portrait,
                              ),
                              labelText: 'Full name',
                              labelStyle: TextStyle(
                                  color: Colors.grey[400], fontSize: 12),
                            ),
                            validator: validateName,
                            onChanged: (value) {
                              name = value;
                            },
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
                            onChanged: (value) {
                              email = value;
                            },
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
                            onChanged: (value) {
                              pwd = value;
                            },
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
              isLoad
                  ? CircularProgressIndicator()
                  : FlatButton(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                      ),
                      onPressed: () async {
                        print('$name $email $pwd');
                        if (!_formKey.currentState.validate()) {
                          setState(() {
                            _autoval = true;
                          });
                          HapticFeedback.vibrate();
                          return;
                        }
                        type = 1;
                        setState(() {
                          isLoad = true;
                        });
                        var res = await Auth.sign(name, email, pwd, null);
                        if (res > -10) {
                          //ERROR DIALOG res==226 -> email in use
                          //ERROR DIALOG res==-1 -> something went wrong
                          setState(() {
                            isLoad = false;
                          });
                          if (res == 201) Navigator.pushNamed(context, '/otp');
                        }
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

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool autoE = false, autoP = false, isLoad = false;
  final GlobalKey<FormState> _emailKey = GlobalKey();
  final GlobalKey<FormState> _pwdKey = GlobalKey();
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
                    Form(
                      key: _emailKey,
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          icon: Icon(Icons.email),
                          labelText: 'Email address',
                          labelStyle:
                              TextStyle(color: Colors.grey[400], fontSize: 12),
                        ),
                        onChanged: (value) {
                          email = value;
                        },
                        validator: validateEmail,
                        autovalidate: autoE,
                      ),
                    ),
                    Form(
                      key: _pwdKey,
                      child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        validator: validatePwd,
                        autovalidate: autoP,
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock),
                          labelText: 'Password',
                          labelStyle:
                              TextStyle(color: Colors.grey[400], fontSize: 12),
                        ),
                        obscureText: true,
                        onChanged: (value) {
                          pwd = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: gapH * 0.07,
                    ),
                    isLoad
                        ? CircularProgressIndicator()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  if (!_emailKey.currentState.validate()) {
                                    setState(() {
                                      autoP = false;
                                      autoE = true;
                                    });
                                    return;
                                  }
                                  type = 2;
                                  setState(() {
                                    isLoad = true;
                                  });
                                  var res = await Auth.otpfPwd(email);
                                  if (res > -10) {
                                    //ERROR DIALOG res==404 -> email not avail
                                    //ERROR DIALOG res==-1 -> something went wrong
                                    setState(() {
                                      isLoad = false;
                                    });
                                    if (res == 200)
                                      Navigator.pushNamed(context, '/otp');
                                  }
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
                                onPressed: () async {
                                  if (!_emailKey.currentState.validate() ||
                                      !_pwdKey.currentState.validate()) {
                                    setState(() {
                                      autoE = true;
                                      autoP = true;
                                    });
                                    return;
                                  }

                                  setState(() {
                                    isLoad = true;
                                  });

                                  var res = await Auth.login(email, pwd);
                                  if (res > -10) {
                                    //ERROR DIALOG res==226 -> email in use
                                    //ERROR DIALOG res==-1 -> something went wrong
                                    setState(() {
                                      isLoad = false;
                                    });
                                    if (res == 201) {
                                      // Navigator.of(context).pushAndRemoveUntil(
                                      //   MaterialPageRoute(
                                      //     builder: (context) => Home(),
                                      //   ),
                                      //   (_) => false,
                                      // );
                                    }
                                  }
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
  bool isStu = true, isLoad = false;
  var otp;
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
                  onChanged: (value) {
                    otp = value;
                  },
                ),
              ),
              SizedBox(
                height: gapH * 0.065,
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
                              selectedColor: Colors.blue,
                              pressElevation: 0,
                              padding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 20,
                              ),
                              label: Text(
                                'Student',
                                style: TextStyle(
                                  //    fontSize: 16,
                                  color: isStu ? colors[6] : colors[7],
                                  //   fontWeight: FontWeight.w500,
                                ),
                              ),
                              selected: isStu,
                              onSelected: (p) {
                                setState(() {
                                  isStu = true;
                                });
                              },
                            ),
                            SizedBox(
                              width: gapW * 0.04,
                            ),
                            ChoiceChip(
                              selectedColor: Colors.blue,
                              pressElevation: 0,
                              padding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 20,
                              ),
                              label: Text(
                                'Teacher',
                                style: TextStyle(
                                  // fontSize: 16,
                                  color: !isStu ? colors[6] : colors[7],
                                  // fontWeight: FontWeight.w500,
                                ),
                              ),
                              selected: !isStu,
                              onSelected: (p) {
                                setState(() {
                                  isStu = false;
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
              isLoad
                  ? CircularProgressIndicator()
                  : FlatButton(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                      ),
                      onPressed: () async {
                        if (otp == null) {
                          HapticFeedback.vibrate();
                          return;
                        }
                        setState(() {
                          isLoad = true;
                        });
                        if (type == 1) {
                          print('$email $isStu');
                          var res = await Auth.fPwd(email, otp);
                          if (res > -10) {
                            //ERROR DIALOG res==400  wrong otp
                            //ERROR DIALOG res==-1 -> something went wrong
                            setState(() {
                              isLoad = false;
                            });
                            //if(res==201) {Navigator.of(context).pushAndRemoveUntil(
                            //   MaterialPageRoute(
                            //     builder: (context) => Home(),
                            //   ),
                            //   (_) => false,
                            // );}
                          }
                        } else {
                          print('$email $otp');
                          var res = await Auth.fPwd(email, otp);
                          if (res > -10) {
                            //ERROR DIALOG res==400  wrong otp
                            //ERROR DIALOG res==-1 -> something went wrong
                            setState(() {
                              isLoad = false;
                            });
                            if (res == 200) {
                              Navigator.pushNamed(context, '/changepwd');
                            }
                          }
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
  final GlobalKey<FormState> _formK = GlobalKey();
  bool _autoval = false, isLoad = false;
  var pwd;
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
                child: Form(
                  key: _formK,
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
                        onChanged: (value) {
                          pwd = value;
                        },
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
                        autovalidate: _autoval,
                        validator: (value) => (value != _passwordControl.text)
                            ? 'Passwords do not match!'
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: gapH * 0.1,
              ),
              isLoad
                  ? CircularProgressIndicator()
                  : FlatButton(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                      ),
                      onPressed: () async {
                        if (!_formK.currentState.validate()) {
                          setState(() {
                            _autoval = true;
                          });
                          return;
                        }
                        setState(() {
                          isLoad = true;
                        });
                        var res = await Auth.changePwd(pwd);
                        if (res > -10) {
                          //ERROR DIALOG res==401 -> token expired
                          //ERROR DIALOG res==-1 -> something went wrong
                          setState(() {
                            isLoad = false;
                          });
                        }
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
  if (!RegExp(r'^[A-Z][a-z A-Z]{2,14}$').hasMatch(value))
    return 'Name format';
  else
    return null;
}

String validatePwd(value) {
  if (value.length < 4)
    return 'Password is too short!';
  else if (value.length > 10)
    return 'Password is too long!';
  else
    return null;
}

String validateEmail(value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp _regex = RegExp(pattern);
  if (!_regex.hasMatch(value))
    return 'Enter valid email';
  else
    return null;
}
