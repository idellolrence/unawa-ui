import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_up/components/my_button.dart';
import 'package:sign_up/components/my_textfield.dart';
import 'package:sign_up/components/square_tile.dart';
import 'package:sign_up/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign user in method
  void signUserUp() async {

    // show loading circle
    showDialog(context: context, builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
        );
      },
    );

    // try creating the user
    try {
      if (passwordController.text == confirmPasswordController.text){
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, 
         password: passwordController.text,
        ); 
      } else {
        // show error message, passwords do no match
        showErrorMessage("Passwords do not match.");
      }

    // pop the loading circle
    Navigator.pop(context);

    } on FirebaseAuthException catch (e) {
      
      // pop the loading circle
      Navigator.pop(context);

      // show error message
      showErrorMessage(e.code);
      
    }
  }

  // error message to user
  void showErrorMessage(String message) {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 25),
                // logo 
                const Icon(
                  Icons.lock,
                  size: 85,
                  ),
            
                  const SizedBox(height: 50),
            
                // let's create an account for you
                Text('Let\'s create an account for you!',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                  ),
                ),
            
                const SizedBox(height: 25),
            
                // username textfield
                MyTextfield(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
            
                const SizedBox(height: 10),
            
                // password textfield
                MyTextfield(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
            
                const SizedBox(height: 10),
            
                // confirm password textfield
                MyTextfield(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
            
                const SizedBox(height: 10),
            
                const SizedBox(height: 25),
            
                //sign up button
                MyButton(
                  onTap: signUserUp,
                  text: ('Sign Up'),
                ),
            
                const SizedBox(height: 50),
            
                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                          ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
            
                const SizedBox(height: 50),
            
                // google sign in button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
            
                    // google button
                    SquareTile(
                      onTap: () => AuthService().signInWithGoogle(),
                      imagePath: 'lib/assets/google.png',
                      )
                  ],
                ),
            
                const SizedBox(height: 50),
            
                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login now',
                        style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                                        ),
                    ),
                 ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}