import 'package:flutter/material.dart';


class MyTextField extends StatelessWidget {
  final String hintText;
  final Icon icon;
  final TextEditingController controller;
  final bool obscureText;
  const MyTextField(
      {super.key,
      required this.hintText,
      required this.icon,
      required this.controller,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade900),
        prefixIcon: icon,
        prefixIconColor: Colors.grey.shade900,
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
          color: Colors.grey.shade900,
        )),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
          color: Colors.grey.shade900,
        )),
      ),
    );
  }
}
