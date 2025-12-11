import 'package:flutter/material.dart';

class TileWidget extends StatelessWidget {
  final int value;

  const TileWidget({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,

      decoration: BoxDecoration(
        color: value == 0 ? Colors.grey[300] : getTileColor(value),
        borderRadius: BorderRadius.circular(12),
      ),

      child: AnimatedScale(
        scale: value == 0 ? 1.0 : 1.08,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,

        child: Center(
          child: AnimatedOpacity(
            opacity: value == 0 ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 180),
            child: Text(
              value == 0 ? "" : "$value",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color getTileColor(int value) {
    switch (value) {
      case 2:
        return Colors.orange.shade100;
      case 4:
        return Colors.orange.shade200;
      case 8:
        return Colors.orange.shade300;
      case 16:
        return Colors.orange.shade400;
      case 32:
        return Colors.orange.shade500;
      case 64:
        return Colors.orange.shade600;
      case 128:
        return Colors.orange.shade700;
      case 256:
        return Colors.deepOrange.shade400;
      case 512:
        return Colors.deepOrange.shade500;
      case 1024:
        return Colors.deepOrange.shade600;
      case 2048:
        return Colors.amber.shade700;
      default:
        return Colors.black87;
    }
  }
}
