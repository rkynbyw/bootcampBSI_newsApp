import 'package:flutter/material.dart';

class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color circleColor;
  final VoidCallback onPressed;

  CircleIconButton({
    required this.icon,
    required this.iconColor,
    required this.circleColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40.0, // Adjust the size of the circle as needed
        height: 40.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: circleColor,
        ),
        child: Center(
          child: IconButton(
            icon: Icon(
              icon,
              color: iconColor,
            ),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}