import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hili_helpers/components/front.dart';
import 'package:hili_helpers/pages/login_page.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}); // Use Key? key instead of super.key
  static String id = 'register_page';

  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  void saveUserData(BuildContext context) async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text;

    // Check if all fields are filled
    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      try {
        // Create user account using Firebase Authentication
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'address': '',
          'birthdate': '',
          'email': email,
          'gender': '',
          'name': name,
          'phoneNumber': '',
          'status': '',
        });

        // Navigate to login page after successful registration
        Navigator.pushNamed(context, LoginPage.id);
      } catch (error) {
        // Handle error if registration fails
        print("Failed to register user: $error");
        // Optionally, show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to register user. Please try again."),
        ));
      }
    } else {
      // Show an error message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please fill in all fields."),
      ));
    }
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
                  controller: nameController,
                  hintText: 'Name',
                  obscureText: false,
                  onChanged: (value) {},
                  validator: (value) {
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: emailController,
                  hintText: 'Email Address',
                  obscureText: false,
                  onChanged: (value) {},
                  validator: (value) {
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  onChanged: (value) {},
                  validator: (value) {
                    return null;
                  },
                ),
                const SizedBox(height: 35),
                Hero(
                  tag: 'register_btn',
                  child: CustomButton(
                    buttonText: 'Create Account',
                    onPressed: () {
                      // Call function to save user data
                      saveUserData(context);
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
