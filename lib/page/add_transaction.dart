import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';
import '../elements/custom.dart' as custom;
import '../page/product.dart' as productPage;
import 'transaction.dart' as transaction;
import '../elements/config.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class AddTransaction extends StatefulWidget {
  @override
  AddTransaction({this.productsId, this.name = ""});
  final String productsId, name;
  _AddTransaction createState() => _AddTransaction();
}

class _AddTransaction extends State<AddTransaction> {
  final transactionCode = TextEditingController();
  final totalPrice = TextEditingController();
  final productNameController = TextEditingController();
  final productPriceController = TextEditingController();
  final productStockController = TextEditingController();
  String generatedNumber;
  bool isLoading = false;
  int totalPrices = 0;
  List<dynamic> product;
  int totalProduct = 0;
  
  @override
  void initState() {
    super.initState();
    generateNumber();
    setState(() {
      transactionCode.text = generatedNumber;
      totalPrice.text = totalPrices.toString();
    });
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      getProducts(barcodeScanRes);
    } on PlatformException {
      print('sjdjsk');
    }
  }

  void getProducts(productsId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('loginToken');
    String key = "Bearer $token";

    if(productsId != "-1") {
      final response = await http.get(Uri.parse("$url/api/auth/products/get/$productsId"),
      headers: <String, String> {
        'Accept': 'application/json',
        'Authorization': key,
      },
      );
      Map<String, dynamic> json = jsonDecode(response.body);
      if(json["data"] != null) {
        setState(() {
          totalPrices += json["data"]["price"];
          totalPrice.text = totalPrices.toString();
          if(product == null) {
            product = [json["data"]];
          } else {
            product.add(json["data"]);
          }

          totalProduct += 1;
        });
      } else {
        AlertDialog noItems = AlertDialog(
          title: Text("Sorry"),
          content: Text("Items not found in your inventory."),
          actions: [
            TextButton(
              child: Text("Close"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return noItems;
          },
        );
      }
    }
  }

  void saveTransaction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('loginToken');
    String key = "Bearer $token";

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    final response = await http.post(
      Uri.parse('$url/api/auth/transaction'),
      body: <String, dynamic> {
        'price': totalPrice.value.text,
        'sell_at': formattedDate,
        'kode': transactionCode.value.text,
        'tipe': 'pemasukan'
      },
      headers: <String, String> {
        'Accept': 'application/json',
        'Authorization': key,
      },
    );

    Map<String, dynamic> json = jsonDecode(response.body);

    product.forEach((value) async {
      await http.post(
        Uri.parse('$url/api/auth/transaction/insertItem'),
        body: <String, dynamic> {
          'id': json["data"]["id"].toString(),
          'products': value["id"].toString(),
        },
        headers: <String, String> {
          'Accept': 'application/json',
          'Authorization': key,
        },
      );
    });

    int count = 0;
    Navigator.of(context).popUntil((_) => count++ >= 2);
    Navigator.push(
      context, 
      PageTransition(
        child: transaction.Transaction(),
        type: PageTransitionType.rightToLeft
      )
    );
  }

  void generateNumber() {
    var random = new Random();
    int min = 10000;
    int max = 99999;
    setState(() {
      generatedNumber = "#${(min + random.nextInt(max - min)).toString()}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: custom.customAppBar("Add Transaction"),
      body: 
      Stack(
        children: [
          isLoading ?
          LinearProgressIndicator(minHeight: 1, backgroundColor: Colors.blue) :
          SizedBox(height: 0),
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Enter form below to add transaction", style: TextStyle(color: Colors.black87, fontSize: 15)),
                    SizedBox(height: 10),
                    Text("Transaction Data", style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    custom.CustomTextField(controller: transactionCode, hintText: "Transaction Id", obscureText: false, enabled: false),
                    SizedBox(height: 20),
                    custom.CustomTextField(controller: totalPrice, hintText: "Total", obscureText: false, enabled: false),
                    SizedBox(height: 20),
                    custom.ButtonPrimary(buttonText: "Add Product", buttonPressed: scanBarcodeNormal),
                    SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: totalProduct,
                      itemBuilder: (context, index) {
                        return custom.ListProduct(
                          img: "https://bwipjs-api.metafloor.com/?bcid=code128&text=${product[index]["products_id"]}",
                          name: product[index]["name"],
                          price: product[index]["price"].toString(),
                          buttonPressed: null
                        );
                      }
                    ),
                  ],
                ),
              )
            ),
          )
        ]
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: saveTransaction,
        child: Icon(Icons.save, color: Colors.white)
      ),
    );
  }
}