import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hili_helpers/components/textfield.dart';
import 'package:hili_helpers/components/buttons.dart';
import 'package:hili_helpers/pages/register_page.dart';
import 'package:hili_helpers/pages/front_page.dart';
import 'package:hili_helpers/components/auth.dart';
import 'package:hili_helpers/pages/home_page.dart'; // Import the home page
import 'package:hili_helpers/pages/forgot_password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String id = 'login_page';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInwithEmailAndPassword() async {
    final String email = _controllerEmail.text.trim();
    final String password = _controllerPassword.text;

    if (!_isValidEmail(email)) {
      setState(() {
        errorMessage = 'Invalid email format';
      });
      return;
    }

    try {
      await Auth().signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigate to home page upon successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'invalid-email-password') {
          errorMessage = 'Invalid email or password';
        } else {
          errorMessage = e.message ?? 'An unknown error occurred.';
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = 'An unknown error occurred.';
      });
    }
  }

  bool _isValidEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  void _goToForgotPasswordPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE4E6ED),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: BackButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, FrontPage.id);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Login Account',
                  style: TextStyle(
                    color: Color(0xFFD3A877),
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'DM Sans',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                const Text(
                  'Welcome back, glad to have you back!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF0C171D),
                    fontSize: 12,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 50),
                Text(
                  errorMessage ?? '',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
                MyTextField(
                  controller: _controllerEmail,
                  hintText: 'Email',
                  obscureText: false,
                  onChanged: (value) {},
                  validator: (value) {
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: _controllerPassword,
                  hintText: 'Password',
                  obscureText: true,
                  onChanged: (value) {},
                  validator: (value) {
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _goToForgotPasswordPage,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Hero(
                  tag: 'login_btn',
                  child: CustomButton(
                    buttonText: 'Login',
                    onPressed: () {
                      signInwithEmailAndPassword();
                    },
                  ),
                ),
                const SizedBox(height: 5),
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
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, RegisterPage.id);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account? '),
                      Text(
                        'Register now!',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
