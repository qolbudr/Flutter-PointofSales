import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';
import '../elements/custom.dart' as custom;
import '../page/product.dart' as productPage;
import '../elements/config.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class AddProduct extends StatefulWidget {
  @override
  AddProduct({this.productsId, this.name = ""});
  final String productsId, name;
  AddProductState createState() => AddProductState();
}

class AddProductState extends State<AddProduct> {
  final productIdController = TextEditingController();
  final productNameController = TextEditingController();
  final productPriceController = TextEditingController();
  final productStockController = TextEditingController();
  bool isLoading = false;
  
  @override
  void initState() {
    super.initState();
    setState(() {
      productIdController.text = widget.productsId;
      productNameController.text = widget.name;
    });
  }

  void saveProduct() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('loginToken');
    String key = "Bearer $token";
    String message = " ";

    setState(() {
      isLoading = true;
    });

    final response = await http.post(
      Uri.parse("$url/api/auth/products"),
      headers: <String, String> {
        'Accept': 'application/json',
        'Authorization': key,
      },
      body: <String, dynamic> {
        'products_id': widget.productsId,
        'name': productNameController.text,
        'count': productStockController.value.text,
        'price': productPriceController.value.text,
      },
    );

    setState(() {
      if(response.statusCode == 200) {
        isLoading = false;
        int count = 0;
        Navigator.of(context).popUntil((_) => count++ >= 2);
        Navigator.push(
          context, 
          PageTransition(
            child: productPage.Product(),
            type: PageTransitionType.rightToLeft
          )
        );
      } else {
        Map<String, dynamic> error = jsonDecode(response.body)["errors"];
        error.forEach((key, value) {
          if(message == " ") {
            message = value[0];
          }
        });

        setState(() {
          isLoading = false;
        });

        AlertDialog errorDialog = AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("Close"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return errorDialog;
          },
        );
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: custom.customAppBar("Add Product"),
      body: 
      Stack(
        children: [
          isLoading ?
          LinearProgressIndicator(minHeight: 1, backgroundColor: Colors.blue) :
          SizedBox(height: 0),
          Container(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Enter form below to add products", style: TextStyle(color: Colors.black87, fontSize: 15)),
                    SizedBox(height: 10),
                    Text("Product Data", style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    custom.CustomTextField(controller: productIdController, hintText: "Product Id", obscureText: false, enabled: false),
                    SizedBox(height: 20),
                    custom.CustomTextField(controller: productNameController, hintText: "Name", obscureText: false, enabled: (productNameController.value.text == "") ? true : false),
                    SizedBox(height: 20),
                    custom.CustomTextField(controller: productPriceController, hintText: "Price (Per Item)", obscureText: false, type: TextInputType.number),
                    SizedBox(height: 20),
                    custom.CustomTextField(controller: productStockController, hintText: "Stock", obscureText: false, type: TextInputType.number),
                    SizedBox(height: 20),
                  ],
                ),
              )
            ),
          )
        ]
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: saveProduct,
        child: Icon(Icons.add, color: Colors.white)
      ),
    );
  }
}