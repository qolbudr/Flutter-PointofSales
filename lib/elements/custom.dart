import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({this.controller, this.hintText, this.obscureText});
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
         BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ), 
        ]
      ),
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14,
          color: Colors.black38,
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 10, 40, 10),
        filled: true, 
        fillColor: Colors.white,
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

class CustomButton extends StatelessWidget {
  CustomButton({this.buttonPressed, this.buttonText});
  final void Function() buttonPressed;
  final String buttonText;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: buttonPressed,
      child: Center(
        heightFactor: 3,
        child: Text(buttonText, style: TextStyle(fontSize: 14, color: Colors.white))
      )
    );
  }
}