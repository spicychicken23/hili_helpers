import 'package:flutter/material.dart';
import 'package:hili_helpers/components/widget_tree.dart';
import 'package:hili_helpers/pages/services_page.dart';
import 'package:hili_helpers/pages/activity_page.dart';
import 'package:hili_helpers/pages/helper_page.dart';
import 'package:hili_helpers/pages/home_page.dart';
import 'package:hili_helpers/pages/userprofile_page.dart';
import 'pages/front_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WidgetTree(),
      routes: {
        FrontPage.id: (context) => const FrontPage(),
        LoginPage.id: (context) => const LoginPage(),
        RegisterPage.id: (context) => RegisterPage(),
        FnbPage.id: (context) => FnbPage(),
        ActPage.id: (context) => ActPage(),
        HomePage.id: (context) => HomePage(),
        HelperPage.id: (context) => HelperPage(),
        AccountPage.id: (context) => AccountPage()
      },
    ); // MaterialApp
  }
}
