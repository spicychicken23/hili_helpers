import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hili_helpers/components/auth.dart';
import 'package:hili_helpers/navigation.dart';
import 'package:hili_helpers/pages/front_page.dart';
import 'package:hili_helpers/services/database_service.dart';
import 'account_info_page.dart';

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
  final DatabaseService _databaseService = DatabaseService();
  int _currentIndex = 3;
  String? userStatus = 'User';
  String? userName = 'User';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    userStatus = await _databaseService.getStatus();
    userName = await _databaseService.getUsersName();
    setState(() {});
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _showBecomeHelperDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Become a Helper'),
          content: const Text('Are you sure you want to be a helper?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                _showHelperForm();
              },
            ),
          ],
        );
      },
    );
  }

  void _showHelperForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController storeNameController =
            TextEditingController();
        final TextEditingController categoryController =
            TextEditingController();
        String selectedServiceType = 'F&B';
        final List<String> serviceTypes = [
          'F&B',
          'Education',
          'Domestics',
          'Vehicles'
        ];

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Helper Form'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DropdownButtonFormField<String>(
                    value: selectedServiceType,
                    decoration: const InputDecoration(
                      labelText: 'Service Type',
                    ),
                    items: serviceTypes.map((String serviceType) {
                      return DropdownMenuItem<String>(
                        value: serviceType,
                        child: Text(serviceType),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedServiceType = newValue!;
                      });
                    },
                  ),
                  TextField(
                    controller: storeNameController,
                    decoration: const InputDecoration(
                      labelText: 'Store Name',
                    ),
                  ),
                  TextField(
                    controller: categoryController,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Submit'),
                  onPressed: () async {
                    final User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      String prefix;
                      switch (selectedServiceType) {
                        case 'F&B':
                          prefix = 'FNB';
                          break;
                        case 'Education':
                          prefix = 'EDU';
                          break;
                        case 'Domestics':
                          prefix = 'DOM';
                          break;
                        case 'Vehicles':
                          prefix = 'VEH';
                          break;
                        default:
                          prefix = 'GEN';
                      }

                      await FirebaseFirestore.instance
                          .collection('fnbLists')
                          .add({
                        'ID':
                            '$prefix-${DateTime.now().millisecondsSinceEpoch}',
                        'Name': storeNameController.text,
                        'Owner': user.uid,
                        'Category': categoryController.text,
                        'Rating': 0.0,
                        'Raters': 0,
                        'Rate_1': 0,
                        'Rate_2': 0,
                        'Rate_3': 0,
                        'Rate_4': 0,
                        'Rate_5': 0,
                        'Icon': '',
                        'open': false,
                      });
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
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
                  builder: (context) => const ContactInfoPage(),
                ),
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
          StreamBuilder<Object>(
              stream: null,
              builder: (context, snapshot) {
                return Center(child: Text(userName ?? 'Loading...'));
              }),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Contact Info
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                leading: const Icon(Icons.contact_page),
                title: const Text('Contact Info'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContactInfoPage(),
                    ),
                  );
                },
              ),
              // Joined Us
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                leading: const Icon(Icons.group_add),
                title: const Text('Become a Helper'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: _showBecomeHelperDialog,
              ),
              // Settings
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                leading: const Icon(Icons.settings_applications_rounded),
                title: const Text('Settings'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContactInfoPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          // Logout
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
