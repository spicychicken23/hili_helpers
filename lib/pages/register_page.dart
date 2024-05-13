import 'package:flutter/material.dart';
import 'package:hili_helpers/components/textfield.dart';
import 'package:hili_helpers/components/buttons.dart';
import 'package:hili_helpers/pages/login_page.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});
  static String id = 'register_page';

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  void signUserIn() {}

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
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Create an account',
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
                  'Connect with your local services and businesses now!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF0C171D),
                    fontSize: 12,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 50),
                MyTextField(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                  onChanged: (value) {},
                  validator: (value) {},
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: emailController,
                  hintText: 'Email Address',
                  obscureText: false,
                  onChanged: (value) {},
                  validator: (value) {},
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  onChanged: (value) {},
                  validator: (value) {},
                ),
                const SizedBox(height: 35),
                Hero(
                  tag: 'register_btn',
                  child: CustomButton(
                    buttonText: 'Create Account',
                    onPressed: () {
                      Navigator.pushNamed(context, RegisterPage.id);
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
                const SizedBox(height: 25),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, LoginPage.id);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account? '),
                      Text(
                        'Login now!',
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
