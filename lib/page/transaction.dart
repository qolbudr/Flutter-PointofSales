import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';
import '../elements/custom.dart' as custom;
import 'home.dart' as home;
import '../elements/config.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'add_transaction.dart' as add;

class Transaction extends StatefulWidget {
  @override
  _Transaction createState() => _Transaction();
}

class _Transaction extends State<Transaction> {
  bool isLoading = true;
  bool isEmpty = false;
  bool haveItem = false;
  int transactionCount;
  List<dynamic> transaction; 

  void gotoAddTransaction() {
    Navigator.push(
      context,
      PageTransition(
        child: add.AddTransaction(),
        type: PageTransitionType.rightToLeft,
      )
    );
  }

  void getTransaction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('loginToken');
    String key = "Bearer $token";
    List<dynamic> json;   

    final response = await http.get(
      Uri.parse("$url/api/auth/transaction"),
      headers: <String, String> {
        'Accept': 'application/json',
        'Authorization': key,
      },
    );

    setState(() {
      isLoading = true;
    });

    if(this.mounted) {
      try {
        setState(() {
          Map<String, dynamic> data = jsonDecode(response.body);
          json = data["data"];
          if(json.length > 0) {
            haveItem = true;
            isLoading = false;
            isEmpty = false;
            transactionCount = json.length;
            transaction = json;
          } else {
            isLoading = false;
          }
        });
      } on PlatformException {
        print("Something was wrong");
      }
    }
  }

  void initState() {
    super.initState();
    getTransaction();
  }

  void deleteTransaction(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('loginToken');
    String key = "Bearer $token";

    await http.delete(
      Uri.parse("$url/api/auth/transaction/$id"),
      headers: <String, String> {
        'Accept': 'application/json',
        'Authorization': key,
      },
    );
    
    setState(() {
      isLoading = true;
      haveItem = false;
    });

    getTransaction();
  }

  void dispose() {
    super.dispose();
  }

  void getTotal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('loginToken');
    String key = "Bearer $token";

    final response = await http.get(
      Uri.parse("$url/api/auth/transaction"),
      headers: <String, String> {
        'Accept': 'application/json',
        'Authorization': key,
      },
    );

    if(this.mounted) {
      setState(() {
        Map<String, dynamic> data = jsonDecode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: custom.customAppBar("Transaction"),
      body: haveItem ? Container(
        color: Colors.white,
        width: size.width,
        child: Column(
          children: [
            isLoading ?
            LinearProgressIndicator(
              minHeight: 1,
              backgroundColor: Colors.blue,
            ) : SizedBox(height: 1),
            isLoading ? SizedBox(height: 10) : SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 170,
                padding: EdgeInsets.only(left: 10, right:10, bottom: 10),
                child: ListView.builder(
                  itemCount: transactionCount,
                  itemBuilder: (context, index) {
                    return custom.ListTransaction(
                      name: transaction[index]["kode"],
                      price: transaction[index]["price"].toString(),
                      delete: () => {
                        deleteTransaction(transaction[index]["id"])
                      },
                    );
                  }
                )
              ),
            ),
          ]
        ),
      ) :
      Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [ 
            isLoading ?
            LinearProgressIndicator(minHeight: 1, backgroundColor: Colors.blue)
            : SizedBox(height: 1),
            SizedBox(height: MediaQuery.of(context).size.height*0.2),
            Center(
              child: isLoading ? SizedBox(height: 10) :
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("images/box.png", width: 100),
                  SizedBox(height: 20),
                  Text("No transaction yet.", style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text("Click button in corner to add your transaction", style: TextStyle(color: Colors.black, fontSize: 15), textAlign: TextAlign.center)
                  ),
                ],
              ),
            )
          ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: gotoAddTransaction,
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}