import 'package:flutter/material.dart';

class CompletionPage extends StatelessWidget {
  final VoidCallback onRelearn;
  final VoidCallback onTest;
  final VoidCallback onHome;

  const CompletionPage({
    super.key,
    required this.onRelearn,
    required this.onTest,
    required this.onHome,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the back arrow
        title: const Text("Completion"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "🎉 Congratulations! 🎉\nYou finished learning the alphabet of Filipino Sign Language!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                shadows: [
                  Shadow(
                    blurRadius: 2.0,
                    color: Colors.black12,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30), // Space between text and buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(
                  icon: Icons.refresh,
                  label: "Re-learn",
                  onPressed: onRelearn,
                ),
                const SizedBox(width: 10), // Space between buttons
                _buildButton(
                  icon: Icons.assignment,
                  label: "Test",
                  onPressed: onTest,
                ),
                const SizedBox(width: 10), // Space between buttons
                _buildButton(
                  icon: Icons.home,
                  label: "Home",
                  onPressed: onHome,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.black),
      label: Text(
        label,
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadowColor: Colors.black26,
        elevation: 4,
      ),
    );
  }
}
