import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_up/utils/my_button.dart';
import 'package:sign_up/utils/my_textfield.dart';
import 'package:sign_up/authentication/login_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> passwordReset() async {
    String email = emailController.text.trim();
    if (email.isEmpty) {
      // Show an error if the email field is empty
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('Please enter your email.'),
          );
        },
      );
      return;
    }

    try {
      // Check if the email exists in Firebase Authentication
      final signInMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (signInMethods.isEmpty) {
        // If the email does not exist, show a message
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('Email not found. Please check and try again.'),
            );
          },
        );
        return;
      }

      // If the email exists, send a password reset link
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Show a success dialog
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('Password reset link sent! Check your email.'),
          );
        },
      ).then((_) {
        // After the dialog is closed, navigate to the LoginPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage(onTap: null)),
        );
      });
    } on FirebaseAuthException catch (e) {
      // Display any other Firebase errors
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo_blue.png',
                  width: 250,
                ),
                const Text('We will send your reset password link via Email.'),
                const SizedBox(height: 25),
                MyTextfield(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 25),
                MyButton(
                  onTap: passwordReset,
                  text: 'Reset Password',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_up/utils/my_button.dart';
import 'package:sign_up/utils/my_textfield.dart';
import 'package:sign_up/views/login_page.dart'; // Import the LoginPage

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      // Show dialog to inform the user that the reset email has been sent
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('Password reset link sent! Check your email'),
          );
        },
      ).then((_) {
        // After the dialog is closed, navigate to the LoginPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage(onTap: null)),
        );
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo_blue.png',
                  width: 400,
                ),
                const Text('We will send your reset password link via Email.'),
                const SizedBox(height: 25),
                MyTextfield(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 25),
                MyButton(
                  onTap: passwordReset,
                  text: 'Reset Password',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/