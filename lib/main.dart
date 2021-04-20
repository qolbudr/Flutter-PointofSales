import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'elements/custom.dart' as custom;

void main() {
  runApp(new MaterialApp(
    home: new Splash(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Colors.blue,
      accentColor: Colors.white,
      backgroundColor: Colors.white,
      fontFamily: "DMSans"
    )
  ));
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    setSplash();
  }

  setSplash() async {
    var duration = Duration(seconds: 2);
    return Timer(duration, changeSplash);
  }

  void checkLogin() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // if(prefs.getString("loginToken") != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        return Login();
      }));
    // } else {
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
      //   return false;
      // }));
      // return;
    // }
  }

  void changeSplash() {
    checkLogin();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }
  
  Widget build(BuildContext context) {
    return(
      new Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.blue
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 50),
            ],
          ),
        ),
      )
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController;
  TextEditingController passwordController;

  void forceLogin() async {
    return;
  }

  void gotoSignUp() {
    setState(() {
      print('sjdjksd');
    });
  }

  @override
  Widget build(BuildContext context) {
    return(
      Scaffold(
        body: Container(
          padding: EdgeInsets.all(30),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag_outlined, color: Colors.blue, size: 50)
                  ],
                ),
                SizedBox(height: 60),
                Container(
                  padding: EdgeInsets.symmetric(horizontal:5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Login to your Account", style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w600)),
                      SizedBox(height: 20),
                      custom.CustomTextField(controller: usernameController, hintText: "Username", obscureText: false),
                      SizedBox(height: 20),
                      custom.CustomTextField(controller: passwordController, hintText: "Password", obscureText: true),
                      SizedBox(height: 30),
                      custom.CustomButton(buttonPressed: forceLogin, buttonText: "Sign In"),
                      SizedBox(height: 40),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('or', style: TextStyle(color: Colors.black54, fontSize: 16)),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Doesnt have an account ? "),
                              InkWell(
                                child: Text("Sign Up", style: TextStyle(color: Colors.blue)),
                                onTap: gotoSignUp,
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      )
    );
  }
}