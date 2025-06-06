import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Color primaryColor;
  final Color cardColor;

  const CategoryItem({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.primaryColor,
    required this.cardColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
