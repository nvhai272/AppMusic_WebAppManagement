import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;  // Optional background color

  const GradientBackground({super.key, required this.child, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: backgroundColor == null // Check if backgroundColor is provided
            ? const LinearGradient(
                colors: [Colors.black, Color.fromARGB(255, 219, 4, 76)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,  // If backgroundColor is provided, no gradient
        color: backgroundColor,  // Use solid color if it's provided
      ),
      child: child,
    );
  }
}
