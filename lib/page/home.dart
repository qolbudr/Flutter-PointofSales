import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../elements/custom.dart' as custom;
import '../main.dart' as main;
import '../elements/config.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String date = " ";
  String username = " ";

  initState() {
    super.initState();
    setState(() {
      getDate();
      getUser();
    });
  }

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('loginToken');
    String key = "Bearer $token";
    Map<String, dynamic> json;

    final response = await http.get(
      Uri.parse("$url/api/auth/user"),
      headers: <String, String> {
        'Accept': 'application/json',
        'Authorization': key,
      },
    );

    if(response.statusCode == 200) {
      try {
        json = jsonDecode(response.body);
        prefs.setInt('userId', json['id']);
        prefs.setString('userName', json['username']);
        prefs.setString('userEmail', json['email']);
        setState(() {
          username = json['username'];
        });
      } on FormatException catch (e) {
        logout();
      }
    } else {
      logout();
    }
  }

  void getDate() {
    var now = new DateTime.now().toString();
    var dateParse = DateTime.parse(now);
    var formattedDate = "${dateParse.month} - ${dateParse.year}";
    date = formattedDate;
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
      return main.Prepage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 3,
        shadowColor: Colors.black54,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        backgroundColor: Colors.white,
        title: Text("Home", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold))
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black12, width: 1)),
                ),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 20),
                          child: Icon(Icons.shopping_basket_outlined, color: Colors.black87, size: 20),
                        ), 
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Sales", style: TextStyle(color: Colors.grey, fontSize: 14)),
                            Text(date, style: TextStyle(color: Colors.black87, fontSize: 14)),
                          ],
                        )
                      ]
                    ),
                    Text("Rp. 0", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text("Welcome Back $username", style: TextStyle(color: Colors.black, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
