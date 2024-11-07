import 'package:flutter/material.dart';
import 'authentication/login_page.dart'; // Import the login page

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the Animation Controller
    _controller = AnimationController(
      duration: const Duration(seconds: 1), // Duration for the animation
      vsync: this,
    );

    // Define the animation that scales from 0.5 to 1.0
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    // Start the animation
    _controller.forward();

    // Start the timer to navigate to LoginPage after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) =>
                const LoginPage(onTap: null)), // Navigate to LoginPage
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller when no longer needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _animation,
              child: SizedBox(
                height: 500,
                child: Image.asset(
                    'assets/Logos, Logo Marks, and Launcher Icon/logo_blue.png'), // Your logo
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(), // Loading indicator
          ],
        ),
      ),
    );
  }
}
