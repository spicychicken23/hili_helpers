import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NaviBarState();
}

class _NaviBarState extends State<NavBar> {
  int _currentIndex = 0;
  List<Widget> body = const [
    Icon(Icons.home),
    Icon(Icons.library_books),
    Icon(Icons.notifications),
    Icon(Icons.person),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (int newIndex) {
        setState(() {
          _currentIndex = newIndex;
        });
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
          backgroundColor: Color(0xFFDEE1E8),
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
