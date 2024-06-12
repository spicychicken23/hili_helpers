import 'package:flutter/material.dart';
import 'package:hili_helpers/components/auth.dart';
import 'package:hili_helpers/pages/activity_page.dart';
import 'package:hili_helpers/pages/helper_page.dart';
import 'package:hili_helpers/pages/front_page.dart';
import 'package:hili_helpers/pages/home_page.dart';
import 'package:hili_helpers/pages/userprofile_page.dart';

typedef OnPageChangedCallback = void Function(int);

// ignore: must_be_immutable
class CustomNavigationBar extends StatelessWidget {
  String? userStatus = 'User';
  Future<void> singOut(BuildContext context) async {
    await Auth().signOut();
    Navigator.pushReplacementNamed(context, FrontPage.id);
  }

  final int currentIndex;
  final OnPageChangedCallback onPageChanged;

  CustomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onPageChanged,
    this.userStatus,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, HomePage.id);
            break;
          case 1:
            Navigator.pushNamed(context, ActPage.id);
            break;
          case 2:
            Navigator.pushNamed(context, AccountPage.id);
            break;
          case 3:
            Navigator.pushNamed(context, HelperPage.id);
            break;
          default:
            break;
        }
        onPageChanged(index);
      },
      selectedItemColor: const Color(0xFFD3A877),
      unselectedItemColor: const Color(0xFF595A5D),
      selectedIconTheme: const IconThemeData(color: Color(0xFFD3A877)),
      unselectedIconTheme: const IconThemeData(color: Color(0xFF595A5D)),
      showUnselectedLabels: true,
      iconSize: 21,
      selectedLabelStyle: const TextStyle(fontSize: 10),
      unselectedLabelStyle: const TextStyle(fontSize: 10),
      items: [
        const BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Icons.home),
        ),
        const BottomNavigationBarItem(
          label: 'Activity',
          icon: Icon(Icons.library_books),
        ),
        const BottomNavigationBarItem(
          label: 'Account',
          icon: Icon(Icons.person),
        ),
        if (userStatus == 'Helper')
          const BottomNavigationBarItem(
            label: 'Dashboard',
            icon: Icon(Icons.back_hand_rounded),
          ),
      ],
    );
  }
}
