
import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool? obscureText;
  final Widget? prefixIcon;



  const CustomField({ Key? key,
    required this.controller,
    required this.labelText,
    this.obscureText,
    this.prefixIcon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText ?? false,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: prefixIcon ,
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) =>
      value!.isEmpty ? 'Please enter username' : null,
    );
  }
}

