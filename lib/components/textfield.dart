import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required Null Function(dynamic value) onChanged,
    required String? Function(dynamic value) validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF828282)),
              borderRadius: BorderRadius.circular(20.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFD3A877)),
              borderRadius: BorderRadius.circular(20.0),
            ),
            fillColor: Colors.grey.withOpacity(0.05),
            filled: true,
            hintText: hintText,
            hintStyle: const TextStyle(
                color: Color(0xFF828282), fontFamily: 'Roboto')),
      ),
    );
  }
}
