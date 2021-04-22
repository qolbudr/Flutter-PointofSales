import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({this.controller, this.hintText, this.obscureText, this.focus});
  final TextEditingController controller;
  final FocusNode focus;
  final String hintText;
  final bool obscureText;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey[200])
      ),
      child: TextField(
        focusNode: focus,
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14,
          color: Colors.black38,
        ),
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
          shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
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