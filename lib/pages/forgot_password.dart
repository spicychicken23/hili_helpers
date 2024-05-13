// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hili_helpers/components/textfield.dart';
import 'package:hili_helpers/components/buttons.dart';
import 'package:hili_helpers/pages/login_page.dart';
import 'package:hili_helpers/pages/register_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Function to handle form submission and send password reset email
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        print('Password reset email sent to $email');
      } catch (e) {
        print('Error sending password reset email: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE4E6ED),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, LoginPage.id);
                        },
                      ),
                    ),
                    const SizedBox(height: 10), // Add sized box for spacing
                    const Text(
                      'Forgot Password',
                      style: TextStyle(
                        color: Color(0xFFD3A877),
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'DM Sans',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5), // Add sized box for spacing
                    const SizedBox(height: 50), // Add sized box for spacing
                    MyTextField(
                      controller: _emailController,
                      hintText: 'Email',
                      obscureText: false,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        }
                        // Add additional email validation if needed
                        return null;
                      },
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 20.0),
                    CustomButton(
                      buttonText: 'Submit',
                      onPressed: _submitForm,
                    ),
                    const SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RegisterPage.id);
                      },
                      child: const Text(
                        'Don\'t have an account? Register now!',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
