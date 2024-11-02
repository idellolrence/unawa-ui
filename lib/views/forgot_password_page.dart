import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_up/utils/my_button.dart';
import 'package:sign_up/utils/my_textfield.dart';

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
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Password reset link sent! Check you email')
          );
        }
      );
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
                        'lib/assets/logo_blue.png',
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