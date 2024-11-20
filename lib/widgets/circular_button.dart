import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  const CircularButton({super.key, required this.icon, required this.fn});
  final IconData icon;
  final Function()? fn;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: fn,
      child: Container(
        width: 45, // Width of the button
        height: 45, // Height of the button
        decoration: BoxDecoration(
          color: Colors.white, // Button color
          shape: BoxShape.circle, // Making the container circular
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Shadow color with opacity
              blurRadius: 8.0, // Blur radius for the shadow
              offset: const Offset(0, 4), // Offset of the shadow (x, y)
            ),
          ],
        ),
        child: Icon(
          icon, // Icon inside the button
          color: Colors.blue, // Icon color
        ),
      ),
    );
  }
}
