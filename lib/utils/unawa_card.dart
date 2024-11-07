import 'package:flutter/material.dart';

class UnawaCard extends StatelessWidget {
  final String imagePath;
  final VoidCallback onSwipeRight;
  final VoidCallback onSwipeLeft;

  const UnawaCard({
    super.key,
    required this.imagePath,
    required this.onSwipeRight,
    required this.onSwipeLeft,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null) {
          if (details.primaryVelocity! < 0) {
            onSwipeLeft();
          } else if (details.primaryVelocity! > 0) {
            onSwipeRight();
          }
        }
      },
      child: Image.network(imagePath),
    );
  }
}
