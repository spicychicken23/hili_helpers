//done
//latest

// ignore: file_names
import 'package:flutter/material.dart';
// ignore: unused_import
import 'account_info_page.dart'; // Import the renamed account file

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'User Profile',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const AccountPage(),
//     );
//   }
// }

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key});
  static String id = 'userprofile_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            // Add your action here
          },
        ),
        title: const Text('Account'),
      ),
      body: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactInfoPage()),
              );
            },
            child: Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.blueAccent, // Set color to transparent
                  borderRadius: BorderRadius.circular(75),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.person,
                  size: 70,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Center(child: Text('User Name')),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //contact info
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                leading: const Icon(Icons.contact_page),
                title: const Text('Contact Info'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ContactInfoPage()),
                  );
                },
              ),

              //joined us
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                leading: const Icon(Icons.group_add),
                title: const Text('Become a Helper'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Add your action here
                },
              ),
              //settings
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                leading: const Icon(Icons.settings_applications_rounded),
                title: const Text('Settings'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Add your action here
                },
              ),
            ],
          ),

          //logout
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            leading: const Icon(Icons.logout_sharp),
            title: const Text('Logout'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Add your action here
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
