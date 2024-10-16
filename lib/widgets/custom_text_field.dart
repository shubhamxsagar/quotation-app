import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool readOnly;
  final bool obscureText;


  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.obscureText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
        final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        
        obscureText: obscureText,
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        style: textTheme.displayMedium?.copyWith(fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
