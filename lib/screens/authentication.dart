import 'dart:async';
import 'package:flutter/gestures.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import '../helper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../model/auth_net.dart';
import 'package:provider/provider.dart';

var gapH, gapW, email, pwd;
File pickedImage;
int type = 0;
Timer time;
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
      theme: ThemeData(
        fontFamily: 'Gilroy',
      ),
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
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Gilroy',
                        ),
                      ),
                      TextSpan(
                        text: ' Login',
                        style: TextStyle(
                          color: Colors.blue,
                          fontFamily: 'Gilroy',
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
                            textCapitalization: TextCapitalization.words,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp('[a-z A-Z]'),
                              ),
                            ],
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
                      //ignore pointer
                      disabledColor: Colors.grey,
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
                        FocusScope.of(context).requestFocus(FocusNode());
                        setState(() {
                          isLoad = true;
                        });
                        int res =
                            await Provider.of<Auth>(context, listen: false)
                                .sign(name, email, pwd, pickedImage);
                        if (res > -10 && mounted) {
                          setState(() {
                            isLoad = false;
                          });
                          if (res == 226)
                            showMyDialog(
                                context, false, 'Email already in use!');
                          //ERROR DIALOG res==226 -> email in use
                          else if (res == 400)
                            showMyDialog(
                                context, false, 'Incorrect use of fields!');
                          else if (res == 201) {
                            type = 1;
                            Navigator.pushNamed(context, '/otp');
                          } else
                            showMyDialog(context, true, 'Something went wrong');
                          //ERROR DIALOG res==-1 -> something went wrong
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
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          if (isLoad)
                            HapticFeedback.vibrate();
                          else {
                            pickedImage = null;
                            Navigator.pushReplacementNamed(context, '/login');
                          }
                        },
                      text: ' Login',
                      style: TextStyle(
                        color: Colors.blue,
                        fontFamily: 'Gilroy',
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
                        autovalidate: true,
                        validator: autoP
                            ? validatePwd
                            : (_) {
                                return null;
                              },
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
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  setState(() {
                                    isLoad = true;
                                  });
                                  var res = await Provider.of<Auth>(context,
                                          listen: false)
                                      .otpfPwd(email);
                                  if (res > -10 && mounted) {
                                    setState(() {
                                      isLoad = false;
                                    });
                                    if (res == 400)
                                      showMyDialog(
                                          context, false, 'Email not found!');
                                    //ERROR DIALOG res==400 -> email not avail
                                    else if (res == 200) {
                                      type = 2;
                                      Navigator.pushNamed(context, '/otp');
                                    } else if (res == 308) {
                                      showMyDialog(context, false,
                                          'Please verify your account!');
                                      type = 1;
                                      Navigator.pushNamed(context, '/otp');
                                    } else
                                      showMyDialog(context, true,
                                          'Something went wrong');
                                    //ERROR DIALOG res==-1 -> something went wrong
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
                                      !_pwdKey.currentState.validate() ||
                                      !autoP) {
                                    setState(() {
                                      autoE = true;
                                      autoP = true;
                                    });
                                    return;
                                  }
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  setState(() {
                                    isLoad = true;
                                  });
                                  var res = await Provider.of<Auth>(context,
                                          listen: false)
                                      .login(email, pwd);
                                  if (res > -10 && mounted) {
                                    setState(() {
                                      isLoad = false;
                                    });
                                    if (res == 400)
                                      showMyDialog(
                                          context, true, 'Email not found!');
                                    else if (res == 401) {
                                      showMyDialog(
                                          context, false, 'Wrong password!');
                                    } else if (res == 403) {
                                      showMyDialog(context, false,
                                          'Please verify your account!');
                                      type = 1;
                                      Navigator.pushNamed(context, '/otp');
                                    } else if (res == 200) {
                                      // Navigator.of(context).pushAndRemoveUntil(
                                      //   MaterialPageRoute(
                                      //     builder: (context) => Home(),
                                      //   ),
                                      //   (_) => false,
                                      // );
                                    } else
                                      showMyDialog(context, true,
                                          'Something went wrong');
                                    //ERROR DIALOG res==-1 -> something went wrong
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
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          isLoad
                              ? HapticFeedback.vibrate()
                              : Navigator.pushReplacementNamed(
                                  context, '/signup');
                        },
                      text: ' Sign Up',
                      style: TextStyle(
                        color: Colors.blue,
                        fontFamily: 'Gilroy',
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
  bool isStu = true, isLoad = false, isDis = false;
  var otp;
  @override
  Widget build(BuildContext context) {
    if (type == 1) {
      txt = 'Confirm your E-mail';
      btext = 'Verify account';
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
                  : Column(
                      children: [
                        FlatButton(
                          disabledColor: Colors.grey,
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                          ),
                          onPressed: isDis
                              ? null
                              : () async {
                                  setState(() {
                                    isDis = true;
                                  });

                                  time = Timer(
                                    Duration(seconds: 40),
                                    () {
                                      setState(() {
                                        isDis = false;
                                      });
                                    },
                                  );

                                  int res = await Provider.of<Auth>(context,
                                          listen: false)
                                      .resendOTP(email);
                                  if (res > -10) {
                                    if (res == 400)
                                      showMyDialog(
                                          context, true, 'User not found');
                                    else if (res == 202) {
                                      print('OTP sent');
                                    } else
                                      showMyDialog(context, true,
                                          'Something went wrong');
                                  }
                                },
                          child: Text(
                            'Resend OTP',
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
                        FlatButton(
                          padding: EdgeInsets.symmetric(
                            horizontal: 31,
                          ),
                          onPressed: () async {
                            if (otp == null || otp.length < 1) {
                              HapticFeedback.vibrate();
                              return;
                            }
                            FocusScope.of(context).requestFocus(FocusNode());
                            setState(() {
                              isLoad = true;
                            });
                            if (type == 1) {
                              print('$email $isStu');
                              var res = await Provider.of<Auth>(context,
                                      listen: false)
                                  .otpS(email, otp, !isStu);
                              if (res > -10 && mounted) {
                                setState(() {
                                  isLoad = false;
                                });
                                if (res == 400)
                                  showMyDialog(
                                      context, true, 'Wrong OTP/Expired OTP');
                                //ERROR DIALOG res==400  wrong otp
                                else if (res == 200) {
                                  if (time != null) time.cancel();
                                  // Navigator.of(context).pushAndRemoveUntil(
                                  //   MaterialPageRoute(
                                  //     builder: (context) => Home(),
                                  //   ),
                                  //   (_) => false,
                                  // );
                                } else
                                  showMyDialog(
                                      context, true, 'Something went wrong');
                                //ERROR DIALOG res==-1 -> something went wrong
                              }
                            }
                            if (type == 2) {
                              print('$email $otp');
                              var res = await Provider.of<Auth>(context,
                                      listen: false)
                                  .fPwd(email, otp);
                              if (res > -10 && mounted) {
                                setState(() {
                                  isLoad = false;
                                });
                                if (res == 400)
                                  showMyDialog(
                                      context, true, 'Wrong OTP/Expired OTP');
                                //ERROR DIALOG res==400  wrong otp
                                else if (res == 200) {
                                  if (time != null) time.cancel();
                                  Navigator.pushNamed(context, '/changepwd');
                                } else
                                  showMyDialog(
                                      context, true, 'Something went wrong');
                                //ERROR DIALOG res==-1 -> something went wrong
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
                      ],
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
                        autovalidate: true,
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
                        FocusScope.of(context).requestFocus(FocusNode());
                        setState(() {
                          isLoad = true;
                        });
                        var res =
                            await Provider.of<Auth>(context, listen: false)
                                .changePwd(pwd);
                        if (res > -10 && mounted) {
                          setState(() {
                            isLoad = false;
                          });
                          if (res == 401)
                            showMyDialog(
                                context, false, 'You took too long to think.');
                          //ERROR DIALOG res==401 -> token expired
                          else if (res == 202) {
                            // Navigator.of(context).pushAndRemoveUntil(
                            //   MaterialPageRoute(
                            //     builder: (context) => Home(),
                            //   ),
                            //   (_) => false,
                            // );
                          } else
                            showMyDialog(context, true, 'Something went wrong');
                          //ERROR DIALOG res==-1 -> something went wrong

                          //Success 202
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
