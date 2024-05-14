import 'package:flutter/material.dart';
import 'package:hili_helpers/components/auth.dart';
import 'package:hili_helpers/pages/ACT_page.dart';
import 'package:hili_helpers/pages/front_page.dart';
import 'package:hili_helpers/pages/home_page.dart';

typedef OnPageChangedCallback = void Function(int);

class CustomNavigationBar extends StatelessWidget {
  Future<void> singOut(BuildContext context) async {
    await Auth().signOut();
    Navigator.pushReplacementNamed(context, FrontPage.id);
  }

  final int currentIndex;
  final OnPageChangedCallback onPageChanged;

  const CustomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onPageChanged,
  }) : super(key: key);

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
            break;
          case 3:
            singOut(context);
            break;
        }
        onPageChanged(index);
      },
      selectedItemColor: const Color(0xFFD3A877),
      unselectedItemColor: const Color(0xFF595A5D),
      selectedIconTheme: const IconThemeData(color: Color(0xFFD3A877)),
      unselectedIconTheme: const IconThemeData(color: Color(0xFF595A5D)),
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: 'Activity',
          icon: Icon(Icons.library_books),
        ),
        BottomNavigationBarItem(
          label: 'Notification',
          icon: Icon(Icons.notifications),
        ),
        BottomNavigationBarItem(
          label: 'Account',
          icon: Icon(Icons.person),
        ),
      ],
    );
  }
}
