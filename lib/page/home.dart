import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';
import '../elements/custom.dart' as custom;
import '../main.dart' as main;
import 'product.dart' as product;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String date;
  String username;

  initState() {
    super.initState();
    setState(() {
      getDate();
      getUser();
    });
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

  void gotoProduct() {
    Navigator.push(context, PageTransition(child: product.Product(), type: PageTransitionType.rightToLeft));
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
                  Text("Rp. 0", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 151,
                    color: Colors.white,
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
                            custom.PanelButton(buttonPressed: logout, buttonText: "Transaction", buttonIcon: Icons.money_outlined),
                            custom.PanelButton(buttonPressed: logout, buttonText: "Sign out", buttonIcon: Icons.logout),
                          ],
                        ),
                      ],
                    ),
                  )  
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
                    child: custom.ButtonPrimary(buttonText: "Transaction", buttonPressed: logout)
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
