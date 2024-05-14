import 'package:flutter/material.dart';
import 'package:hili_helpers/components/front.dart';
import 'package:hili_helpers/pages/login_page.dart';
import 'package:hili_helpers/pages/register_page.dart';

class FrontPage extends StatelessWidget {
  const FrontPage({super.key});
  static String id = 'front_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFE4E6ED),
        body: SafeArea(
          child: Center(
              child: Column(children: [
            const SizedBox(height: 50),
            const Logo(imagePath: 'lib/images/Logo Circular.png'),
            const SizedBox(height: 50),
            const Text(
              'Access essential\n services with us.',
              style: TextStyle(
                color: Color(0xFFD3A877),
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontFamily: 'DM Sans',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'We provide easy access\n to your local services and businesses!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF0C171D),
                fontSize: 12,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 50),
            Hero(
              tag: 'login_btn',
              child: CustomButton(
                buttonText: 'Login',
                onPressed: () {
                  Navigator.pushNamed(context, LoginPage.id);
                },
              ),
            ),
            const SizedBox(height: 10),
            Hero(
              tag: 'register_btn',
              child: CustomButton(
                buttonText: 'Create Account',
                isOutlined: true,
                onPressed: () {
                  Navigator.pushNamed(context, RegisterPage.id);
                },
              ),
            ),
          ])),
        ));
  }
}
