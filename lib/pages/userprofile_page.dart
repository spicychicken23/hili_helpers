import 'package:flutter/material.dart';
import 'package:hili_helpers/components/auth.dart';
import 'package:hili_helpers/navigation.dart';
import 'package:hili_helpers/pages/front_page.dart';
import 'package:hili_helpers/services/database_service.dart';
// ignore: unused_import
import 'account_info_page.dart'; // Import the renamed account file

Future<void> signOut(BuildContext context) async {
  await Auth().signOut();
  Navigator.pushReplacementNamed(context, FrontPage.id);
}

class AccountPage extends StatefulWidget {
  AccountPage({super.key});
  static String id = 'userprofile_page';

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  int _currentIndex = 3;

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  late String? userStatus = 'User';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    userStatus = await DatabaseService().getStatus();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
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
                MaterialPageRoute(
                    builder: (context) => const ContactInfoPage()),
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
                    MaterialPageRoute(
                        builder: (context) => const ContactInfoPage()),
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
              signOut(context);
            },
          ),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        userStatus: userStatus,
        currentIndex: _currentIndex,
        onPageChanged: _onPageChanged,
      ),
    );
  }
}
