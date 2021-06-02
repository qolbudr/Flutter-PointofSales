import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:convert';
import "package:intl/intl.dart";
class CustomTextField extends StatelessWidget {
  CustomTextField({this.controller, this.hintText, this.obscureText, this.focus, this.enabled = true, this.type, this.changed});
  final TextEditingController controller;
  final void Function(String) changed;
  final FocusNode focus;
  final String hintText;
  final bool obscureText;
  final bool enabled;
  final TextInputType type;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey[200])
      ),
      child: TextField(
        keyboardType: type ?? TextInputType.text,
        enabled: enabled ?? true,
        focusNode: focus,
        onChanged: changed,
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14,
          color: Colors.black38,
        ),
        disabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(5), 
          borderSide: BorderSide(color: Colors.transparent)
        ),
        filled: enabled ? false : true,
        fillColor: enabled ? Colors.transparent : Colors.grey[200],
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical:10),
        // filled: true, 
        // fillColor: Colors.white,
          enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(5), 
            borderSide: BorderSide(color: Colors.transparent)
          ), 
          focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(5), 
            borderSide: BorderSide(color: Colors.transparent)
          )
        )
      )
    );
  }
}


class ButtonPrimary extends StatelessWidget {
  ButtonPrimary({this.buttonPressed, this.buttonText});
  final void Function() buttonPressed;
  final String buttonText;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(0),
      ),
      onPressed: buttonPressed,
      child: Center(
        heightFactor: 3,
        child: Text(buttonText, style: TextStyle(fontSize: 14, color: Colors.white))
      )
    );
  }
}

class ButtonDanger extends StatelessWidget {
  ButtonDanger({this.buttonPressed, this.buttonText});
  final void Function() buttonPressed;
  final String buttonText;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
        elevation: MaterialStateProperty.all<double>(0),
      ),
      onPressed: buttonPressed,
      child: Center(
        heightFactor: 3,
        child: Text(buttonText, style: TextStyle(fontSize: 14, color: Colors.white))
      )
    );
  }
}

class ButtonOutlined extends StatelessWidget {
  ButtonOutlined({this.buttonPressed, this.buttonText});
  final void Function() buttonPressed;
  final String buttonText;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200])
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          elevation: MaterialStateProperty.all<double>(0),
          overlayColor: MaterialStateProperty.all<Color>(Colors.grey[200]),
        ),
        onPressed: buttonPressed,
        child: Center(
          heightFactor: 3,
          child: Text(buttonText, style: TextStyle(fontSize: 14, color: Colors.black))
        )
      )
    );
  }
}

class PanelButton extends StatelessWidget {
  PanelButton({this.buttonPressed, this.buttonText, this.buttonIcon});
  final void Function() buttonPressed;
  final IconData buttonIcon;
  final String buttonText;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.28,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200])
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          elevation: MaterialStateProperty.all<double>(0),
          overlayColor: MaterialStateProperty.all<Color>(Colors.grey[200]),
        ),
        onPressed: buttonPressed,
        child: Center(
          heightFactor: 2,
          child: Column(
            children: [
              Icon(buttonIcon, color: Colors.blue),
              SizedBox(height: 10),
              Text(buttonText, style: TextStyle(fontSize: 12, color: Colors.black)),
            ],
          )
        )
      )
    );
  }
}

class ListProduct extends StatelessWidget {
  ListProduct({this.buttonPressed, this.price, this.name, this.img});
  final void Function() buttonPressed;
  final String price, name, img;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: buttonPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        elevation: MaterialStateProperty.all<double>(0),
        overlayColor: MaterialStateProperty.all<Color>(Colors.grey[200]),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black12)
          )
        ),
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child: Image.network(img, width: 40),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
                Text("Rp $price", style: TextStyle(fontSize: 12, color: Colors.black87)),
              ],
            ),
          ],
        ),
      ),
    );         
  }
}

class ListTransaction extends StatelessWidget {
  ListTransaction({this.price, this.name, this.delete});
  final void Function() delete;
  final String price, name;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black12)
          )
        ),
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child: Icon(Icons.bookmark_outline, size: 40, color: Colors.blue),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
                Text("Rp $price", style: TextStyle(fontSize: 12, color: Colors.black87)),
              ],
            ),
        ],
      ),
    
            IconButton(icon: Icon(Icons.delete), onPressed: delete),
          ],
        ) 
      );        
  }
}

PreferredSizeWidget customAppBar(text)  {
  return AppBar(
    elevation: 3,
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(
      color: Colors.black
    ),
    title: Text(text, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold))
  );
}

class TransactionChart extends StatefulWidget {
  @override
  _TransactionChart createState() => _TransactionChart();
}

class _TransactionChart extends State<TransactionChart> { 
  String weekNumber = '0';
  int even = 0;
  double maxValue = 0;
  List <dynamic> totalTransaction;
  List <FlSpot> transactionChart = [];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue,
              Color(0xff64b5f6),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 37,
                ),
                Text(
                  "Week $weekNumber",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  'Transactions',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                IconButton(icon: Icon(Icons.refresh), onPressed: getWeekChart),
                const SizedBox(
                  height: 37,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                    child: LineChart(
                      transactionData(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void initState() {
    super.initState();
    setState(() {
      totalTransaction = [0];
      getWeekChart();
    });
  }

  void getWeekChart() async {
    weekNumber = '0';
    even = 0;
    maxValue = 0;
    totalTransaction = [0];
    transactionChart = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('loginToken');
    String key = "Bearer $token";
    Map<String, dynamic> data;

    final response = await http.get(
      Uri.parse("$url/api/auth/transaction/week"),
      headers: <String, String> {
        'Accept': 'application/json',
        'Authorization': key,
      },
    );

    if(response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body);
        totalTransaction = data['data']['totalTransaction'];
        weekNumber = data['data']['weekNumber'].toString();
        maxValue = reciprocal(data['data']['maxValue'].toDouble());
        getFlSpot();
      });
    }
  }

  String getYLabel(value) {
    var data;
    data = NumberFormat.compactCurrency(
      decimalDigits: 0,
      symbol: '',
    ).format(value);
    return data;
  }

  double reciprocal(double d) => d/1;

  void getFlSpot() {
    double i = 0;
    totalTransaction.forEach((value) {
      transactionChart.add(FlSpot(i, reciprocal(value.toDouble())));
      i++;
    });
  }

  LineChartData transactionData() {
  return LineChartData(
    lineTouchData: LineTouchData(
      enabled: false,
    ),
    gridData: FlGridData(
      show: false,
    ),
    titlesData: FlTitlesData(
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        getTextStyles: (value) => const TextStyle(
          color: Colors.white,
          fontSize: 9,
        ),
        margin: 10,
        getTitles: (value) {
          if(value == 0)
            return "Mon";
          else if(value == 1)
            return "Tue";
          else if(value == 2)
            return "Wed";
          else if(value == 3)
            return "Thu";
          else if(value == 4)
            return "Fri";
          else if(value == 5)
            return "Sat";
          else if(value == 6)
            return "Sun";
          else
            return "";
        },
      ),
      leftTitles: SideTitles(
        showTitles: true,
        getTextStyles: (value) => const TextStyle(
          color: Colors.white,
          fontSize: 9,
        ),
        getTitles: (value) {
          even++;
          if(even % 2 != 0) {
            if(value == maxValue) {
              even = 0;
            }
            return getYLabel(value.toInt());
          } else {
            return '';
          }
        },
        margin: 8,
        reservedSize: 30,
      ),
    ),
    borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0x99aa4cfc),
            width: 2,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        )),
    minX: 0,
    maxX: 6,
    maxY: maxValue,
    minY: 0,
    lineBarsData: linesBarData2(),
  );
}

  List<LineChartBarData> linesBarData2() {
    return [
      LineChartBarData(
        spots: transactionChart,
        isCurved: true,
        colors: const [
          Color(0x99aa4cfc),
        ],
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(show: true, colors: [
          const Color(0x33aa4cfc),
        ]),
      ),
    ];
  }
}
