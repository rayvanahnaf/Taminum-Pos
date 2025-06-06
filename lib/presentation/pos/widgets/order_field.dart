import 'package:flutter/material.dart';

class OrderField extends StatelessWidget {
  final String labelText;

  const OrderField({
    Key? key,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        enabled: false,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.white),
          border: const UnderlineInputBorder(),
        ),
      ),
    );
  }
}
