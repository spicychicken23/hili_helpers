import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hili_helpers/components/auth.dart';

class ContactInfoPage extends StatefulWidget {
  const ContactInfoPage({Key? key});

  @override
  State<ContactInfoPage> createState() => _ContactInfoPageState();
}

class _ContactInfoPageState extends State<ContactInfoPage> {
  // Instance for Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Instance for Auth from Auth class
  final Auth _auth = Auth();

  // Instance for database services
  //final DatabaseService _databaseService = DatabaseService();
  //Future<String?> email = _databaseService.getUserEmail();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user data when the page initializes
  }

  Future<void> _loadUserData() async {
    // Get the current user ID
    String? currentUserId = _auth.getCurrentUserId();
    //Future<String?> email = _databaseService.getUserEmail();

    if (currentUserId != null) {
      // Get the user's document from Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUserId).get();

      // Update text controllers with user data from Firestore
      setState(() {
        _nameController.text = userDoc.get('name') ?? '';
        _birthdateController.text = userDoc.get('birthdate') ?? '';
        _genderController.text = userDoc.get('gender') ?? '';
        _emailController.text = userDoc.get('email') ?? '';
        _phoneNumberController.text = userDoc.get('phoneNumber') ?? '';
        _addressController.text = userDoc.get('address') ?? '';
      });
    }
  }

  Future<void> _updateUserData() async {
    // Get the current user ID
    String? currentUserId = _auth.getCurrentUserId();

    if (currentUserId != null) {
      // Update user data in Firestore
      await _firestore.collection('users').doc(currentUserId).update({
        'name': _nameController.text,
        'birthdate': _birthdateController.text,
        'gender': _genderController.text,
        'email': _emailController.text,
        'phoneNumber': _phoneNumberController.text,
        'address': _addressController.text,
      });

      // Optionally: Reload the user data to update the displayed values
      // _loadUserData();
    }
  }

  // Get image
  Future<void> _getImage() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _pickedImage = File(pickedImage.path);
      });
    }
  }

  //
  void _showEditDialog(String title, TextEditingController controller) {
    String updatedValue = controller.text;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change $title'),
          content: TextFormField(
            controller: TextEditingController(text: updatedValue),
            onChanged: (value) {
              updatedValue = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  controller.text = updatedValue;
                });
                _updateUserData();
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //Future<String?> email = _databaseService.getUserEmail();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Account Info'),
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap: _getImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor:
                        const Color.fromARGB(255, 20, 64, 100).withOpacity(0.9),
                    child: _pickedImage == null
                        ? const Icon(Icons.person,
                            size: 60, color: Colors.white)
                        : ClipOval(
                            child:
                                Image.file(_pickedImage!, fit: BoxFit.cover)),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 20, 64, 100),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: _getImage,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Name
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Name'),
            subtitle: Text(_nameController.text),
          ),
          // Birthdate
          ListTile(
            leading: const Icon(Icons.cake),
            title: const Text('Birthdate'),
            subtitle: Text(_birthdateController.text),
            trailing:
                const Icon(Icons.edit, color: Color(0xFFD3A877), size: 16),
            onTap: () {
              _showEditDialog('Birthdate', _birthdateController);
            },
          ),
          // Gender
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Gender'),
            subtitle: Text(_genderController.text),
            trailing:
                const Icon(Icons.edit, color: Color(0xFFD3A877), size: 16),
            onTap: () {
              _showEditDialog('Gender', _genderController);
            },
          ),
          // Email
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Email'),
            subtitle: Text(_emailController.text),
          ),
          // Phone Number
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Phone Number'),
            subtitle: Text(_phoneNumberController.text),
            trailing:
                const Icon(Icons.edit, color: Color(0xFFD3A877), size: 16),
            onTap: () {
              _showEditDialog('Phone Number', _phoneNumberController);
            },
          ),
          // Address
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Address'),
            subtitle: Text(_addressController.text),
            trailing:
                const Icon(Icons.edit, color: Color(0xFFD3A877), size: 16),
            onTap: () {
              _showEditDialog('Address', _addressController);
            },
          ),
        ],
      ),
    );
  }
}
