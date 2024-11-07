import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_up/utils/my_button.dart';
import 'package:sign_up/utils/my_textfield.dart';
import 'package:sign_up/utils/password_field.dart';
import 'package:sign_up/utils/square_tile.dart';
import 'package:sign_up/services/auth_service.dart';
import 'login_page.dart'; // Import your LoginPage here

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Text editing controllers
  final fullNameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Focus nodes for password fields
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Add listeners to manage focus
    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus) {
        confirmPasswordFocusNode.unfocus();
      }
    });

    confirmPasswordFocusNode.addListener(() {
      if (confirmPasswordFocusNode.hasFocus) {
        passwordFocusNode.unfocus();
      }
    });
  }

  @override
  void dispose() {
    // Dispose controllers and focus nodes
    fullNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    ageController.dispose();
    genderController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  // Sign user up method
  void signUserUp() async {
    // Show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Try creating the user
    try {
      if (passwordController.text == confirmPasswordController.text) {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Add user details
        await addUserDetails(
          userCredential.user!.uid,
          fullNameController.text.trim(),
          usernameController.text.trim(),
          emailController.text.trim(),
          int.parse(ageController.text.trim()),
          genderController.text.trim(),
        );

        await FirebaseAuth.instance.signOut();

        // Pop the loading circle
        Navigator.pop(context);
      } else {
        // Show error message if passwords do not match
        showErrorMessage("Passwords do not match.");
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      // Show error message
      showErrorMessage(e.code);
    }
    Navigator.pop(context);
  }

  // Add user details
  Future<void> addUserDetails(String userId, String fullname, String username,
      String email, int age, String gender) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'fullName': fullname,
      'username': username,
      'email': email,
      'age': age,
      'gender': gender,
    });
  }

  // Error message to user
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'assets/logo_blue.png',
                    width: 200,
                  ),

                  // Introduction text
                  Text(
                    'Let\'s create an account for you!',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Full name textfield
                  MyTextfield(
                    controller: fullNameController,
                    hintText: 'Full Name',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // Username textfield
                  MyTextfield(
                    controller: usernameController,
                    hintText: 'Username',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // Email textfield
                  MyTextfield(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // Age textfield
                  MyTextfield(
                    controller: ageController,
                    hintText: 'Age',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // Gender textfield
                  MyTextfield(
                    controller: genderController,
                    hintText: 'Gender',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // Password textfield
                  PasswordField(
                    controller: passwordController,
                    hintText: 'Password',
                    focusNode: passwordFocusNode,
                  ),

                  const SizedBox(height: 10),

                  // Confirm password textfield
                  PasswordField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    focusNode: confirmPasswordFocusNode,
                  ),

                  const SizedBox(height: 20),

                  // Sign up button
                  MyButton(
                    onTap: signUserUp,
                    text: 'Sign Up',
                  ),

                  const SizedBox(height: 25),

                  // Or continue with
                  Row(
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

                  const SizedBox(height: 20),

                  // Google sign-in button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SquareTile(
                        onTap: () async {
                          await AuthService().signInWithGoogle();
                        },
                        imagePath: 'assets/google.png',
                      )
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Already have an account? Login now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(
                                onTap: () {},
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Login now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                      height: 30), // Adjusted to keep some space at the bottom
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_up/utils/my_button.dart';
import 'package:sign_up/utils/my_textfield.dart';
import 'package:sign_up/utils/password_field.dart';
import 'package:sign_up/utils/square_tile.dart';
import 'package:sign_up/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final fullNameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign user in method
  void signUserUp() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try creating the user
    try {
      if (passwordController.text == confirmPasswordController.text) {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // add user details
        await addUserDetails(
          userCredential.user!.uid,
          fullNameController.text.trim(),
          usernameController.text.trim(),
          emailController.text.trim(),
          int.parse(ageController.text.trim()),
          genderController.text.trim(),
        );

        await FirebaseAuth.instance.signOut();

        // pop the loading circle
        Navigator.pop(context);
      } else {
        // show error message, passwords do no match
        showErrorMessage("Passwords do not match.");
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      // show error message
      showErrorMessage(e.code);
    }
    Navigator.pop(context);
  }

  // add user details
  Future<void> addUserDetails(String userId, String fullname, String username,
      String email, int age, String gender) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'fullName': fullname,
      'username': username,
      'email': email,
      'age': age,
      'gender': gender,
    });
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo
                Image.asset(
                  'assets/logo_blue.png',
                  width: 200,
                ),

                // let's create an account for you
                Text(
                  'Let\'s create an account for you!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // full name textfield
                MyTextfield(
                  controller: fullNameController,
                  hintText: 'Full Name',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // username textfield
                MyTextfield(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // email textfield
                MyTextfield(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // age textfield
                MyTextfield(
                  controller: ageController,
                  hintText: 'Age',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // gender textfield
                MyTextfield(
                  controller: genderController,
                  hintText: 'Gender',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                PasswordField(
                  controller: passwordController,
                  hintText: 'Password',
                ),

                const SizedBox(height: 10),

                // confirm password textfield
                PasswordField(
                  controller: passwordController,
                  hintText: 'Confirm Password',
                ),

                const SizedBox(height: 10),

                const SizedBox(height: 25),

                //sign up button
                MyButton(
                  onTap: signUserUp,
                  text: ('Sign Up'),
                ),

                const SizedBox(height: 40),

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

                const SizedBox(height: 20),

                // google sign in button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // google button
                    SquareTile(
                      onTap: () async {
                        await AuthService().signInWithGoogle();
                      },
                      imagePath: 'assets/google.png',
                    )
                  ],
                ),

                const SizedBox(height: 20),

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
*/