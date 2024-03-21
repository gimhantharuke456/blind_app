import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onSingleTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;
  final String label;

  const CustomButton({
    super.key,
    required this.onSingleTap,
    this.onDoubleTap,
    this.onLongPress,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onSingleTap,
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(8.0),
          ),
          height: 100,
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
