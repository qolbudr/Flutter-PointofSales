import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';
import '../elements/custom.dart' as custom;
import '../main.dart' as main;
import 'dart:convert';
import 'dart:async';
import 'product.dart' as product;
import 'transaction.dart' as transaction;
import 'package:http/http.dart' as http;
import 'add_transaction.dart' as add_transaction;
import '../elements/config.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String date;
  String username;
  StreamController _streamController = StreamController();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    getDate();
    getUser();
    getTotal();
    if(this.mounted) {
      _timer = Timer.periodic(Duration(seconds: 5), (timer) => getTotal());
    }
  }

  @override
  void dispose() {
    if(_timer.isActive) _timer.cancel();
    super.dispose();
  }

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('userName');
    });
  }

  void getDate() {
    var now = new DateTime.now().toString();
    var dateParse = DateTime.parse(now);
    var formattedDate = "${dateParse.month}/${dateParse.year}";
    date = formattedDate;
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
      return main.Prepage();
    }));
  }

  void getTotal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('loginToken');
    String key = "Bearer $token";

    final response = await http.get(
      Uri.parse("$url/api/auth/transaction/totalTransaction"),
      headers: <String, String> {
        'Accept': 'application/json',
        'Authorization': key,
      },
    );

    if(this.mounted) {
      setState(() {
        var data = jsonDecode(response.body);
        _streamController.add(data["data"]);
      });
    }
  }

  void gotoProduct() {
    Navigator.push(context, PageTransition(child: product.Product(), type: PageTransitionType.rightToLeft));
  }

  void gotoTransaction() {
    Navigator.push(context, PageTransition(child: transaction.Transaction(), type: PageTransitionType.rightToLeft));
  }

  void gotoAddTransaction() {
    Navigator.push(context, PageTransition(child: add_transaction.AddTransaction(), type: PageTransitionType.rightToLeft));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black12, width: 1)),
                color: Colors.white
              ),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(15),
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
                  StreamBuilder(
                    stream: _streamController.stream,
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Rp. 0", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold));
                      } else {
                        return Text("Rp. ${snapshot.data}", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold));
                      }
                    }
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 151,
                  child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text("Welcome Back, $username!", style: TextStyle(color: Colors.black, fontSize: 14)),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            custom.PanelButton(buttonPressed: gotoProduct, buttonText: "Products", buttonIcon: Icons.shopping_cart_outlined),
                            custom.PanelButton(buttonPressed: gotoTransaction, buttonText: "Transaction", buttonIcon: Icons.business_center_outlined),
                            custom.PanelButton(buttonPressed: logout, buttonText: "Sign out", buttonIcon: Icons.logout),
                          ],
                        ),
                        SizedBox(height: 20),
                        custom.TransactionChart(),
                        SizedBox(height: 100),
                      ],
                    ),
                  )  
                ),
                ),
                  Positioned(
                  bottom: 0,
                  child:
                  Container(
                    padding: EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(top: BorderSide(color: Colors.black12, width: 1)),
                    ),
                    child: custom.ButtonPrimary(buttonText: "Transaction", buttonPressed: gotoAddTransaction)
                  ),
                ),
              ]
            )
          ]
        ),
      ),
    );
  }
}
