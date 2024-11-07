import 'package:flutter/material.dart';
import 'my_textfield.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final FocusNode? focusNode; // FocusNode parameter

  const PasswordField({
    super.key,
    required this.controller,
    this.hintText = 'Password',
    this.focusNode, // Accepting the focusNode
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return MyTextfield(
      controller: widget.controller,
      hintText: widget.hintText,
      obscureText: !isPasswordVisible,
      focusNode: widget.focusNode, // Pass the focusNode
      suffixIcon: IconButton(
        icon: Icon(
          isPasswordVisible ? Icons.visibility : Icons.visibility_off,
        ),
        onPressed: () {
          setState(() {
            isPasswordVisible = !isPasswordVisible;
          });
        },
      ),
    );
  }
}



/*
import 'package:flutter/material.dart';
import 'my_textfield.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  const PasswordField({
    super.key,
    required this.controller,
    this.hintText = 'Password',
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return MyTextfield(
      controller: widget.controller,
      hintText: widget.hintText,
      obscureText: !isPasswordVisible,
      suffixIcon: IconButton(
        icon: Icon(
          isPasswordVisible ? Icons.visibility : Icons.visibility_off,
        ),
        onPressed: () {
          setState(() {
            isPasswordVisible = !isPasswordVisible;
          });
        },
      ),
    );
  }
}
*/