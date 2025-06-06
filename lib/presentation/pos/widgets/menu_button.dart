import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final Widget iconPath;
  final String label;
  final bool isActive;
  final VoidCallback onPressed;
  final bool isImage;
  final double size;

  const MenuButton({
    super.key,
    required this.iconPath,
    required this.label,
    this.isActive = false,
    required this.onPressed,
    this.isImage = false,
    this.size = 90,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0), // Adjusted padding for better spacing
      child: InkWell(
        onTap: onPressed,
        borderRadius: const BorderRadius.all(Radius.circular(6.0)),
        child: Container(
          width: 250, // Set a consistent width for all buttons
          padding: const EdgeInsets.all(10.0), // Adjusted padding for better appearance
          decoration: BoxDecoration(
            color: isActive ? Colors.green : Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(6.0)),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 4),
                blurRadius: 20.0,
                blurStyle: BlurStyle.outer,
                spreadRadius: 0,
                color: Colors.black.withOpacity(0.1),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
            children: [
              iconPath,
              const SizedBox(height: 8.0),
              Text(
                label,
                textAlign: TextAlign.center, // Center the text
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}