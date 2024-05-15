//this file doesnt containing any logic about firebase
//DONE

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Account',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ContactInfoPage(),
    );
  }
}

class ContactInfoPage extends StatefulWidget {
  const ContactInfoPage({Key? key});

  @override
  State<ContactInfoPage> createState() => _ContactInfoPageState();
}

class _ContactInfoPageState extends State<ContactInfoPage> {
  final ImagePicker _imagePicker = ImagePicker();
  String? name;
  String? email;
  String? gender;
  String? birthdate;
  String? address;
  String? phoneNumber;
  File? _pickedImage;

  Future<void> _getImage() async {
    final pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _pickedImage = File(pickedImage.path);
      });
    }
  }

  void _changeName(String newName) {
    setState(() {
      name = newName;
    });
  }

  void _changeBirthdate(String newBirthdate) {
    setState(() {
      birthdate = newBirthdate;
    });
  }

  void _changeGender(String newGender) {
    setState(() {
      gender = newGender;
    });
  }

  void _changeEmail(String newEmail) {
    setState(() {
      email = newEmail;
    });
  }

  void _changePhoneNumber(String newPhoneNumber) {
    setState(() {
      phoneNumber = newPhoneNumber;
    });
  }

  void _changeAddress(String newAddress) {
    setState(() {
      address = newAddress;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          // this one is without icon and hovering display
          // Center(
          //   child: GestureDetector(
          //     onTap: _getImage,
          //     child: CircleAvatar(
          //       radius: 60,
          //       backgroundColor: Colors.blue,
          //       child: _pickedImage == null
          //           ? const Icon(Icons.person, size: 60, color: Colors.white)
          //           : ClipOval(child: Image.file(_pickedImage!, fit: BoxFit.cover)),
          //     ),
          //   ),
          // ),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap: _getImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: const Color.fromARGB(255, 20, 64, 100).withOpacity(0.9),
                    child: _pickedImage == null
                        ? const Icon(Icons.person, size: 60, color: Colors.white)
                        : ClipOval(child: Image.file(_pickedImage!, fit: BoxFit.cover)),
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
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Name'),
            subtitle: Text(name ?? 'Enter your name'),
            trailing: const Text('Change', style: TextStyle(color: Color(0xFFD3A877))),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  String updatedName = name ?? '';
                  return AlertDialog(
                    title: const Text('Change Name'),
                    content: TextFormField(
                      initialValue: name,
                      onChanged: (value) {
                        updatedName = value;
                      },
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _changeName(updatedName);
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.cake),
            title: const Text('Birthdate'),
            subtitle: Text(birthdate ?? 'Select your birthdate'),
            trailing: const Text('Change', style: TextStyle(color: Color(0xFFD3A877))),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  String updatedBirthdate = birthdate ?? '';
                  return AlertDialog(
                    title: const Text('Change Birthdate'),
                    content: TextFormField(
                      initialValue: birthdate,
                      onChanged: (value) {
                        updatedBirthdate = value;
                      },
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _changeBirthdate(updatedBirthdate);
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Gender'),
            subtitle: Text(gender ?? 'Select your gender'),
            trailing: const Text('Change', style: TextStyle(color: Color(0xFFD3A877))),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  String updatedGender = gender ?? '';
                  return AlertDialog(
                    title: const Text('Change Gender'),
                    content: TextFormField(
                      initialValue: gender,
                      onChanged: (value) {
                        updatedGender = value;
                      },
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _changeGender(updatedGender);
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Email'),
            subtitle: Text(email ?? 'Enter your email'),
            trailing: const Text('Change', style: TextStyle(color: Color(0xFFD3A877))),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  String updatedEmail = email ?? '';
                  return AlertDialog(
                    title: const Text('Change Email'),
                    content: TextFormField(
                      initialValue: email,
                      onChanged: (value) {
                        updatedEmail = value;
                      },
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _changeEmail(updatedEmail);
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Phone Number'),
            subtitle: Text(phoneNumber ?? 'Enter your phone number'),
            trailing: const Text('Change', style: TextStyle(color: Color(0xFFD3A877))),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  String updatedPhoneNumber = phoneNumber ?? '';
                  return AlertDialog(
                    title: const Text('Change Phone Number'),
                    content: TextFormField(
                      initialValue: phoneNumber,
                      onChanged: (value) {
                        updatedPhoneNumber = value;
                      },
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _changePhoneNumber(updatedPhoneNumber);
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  );
                },
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Address'),
            subtitle: Text(address ?? 'Enter your address'),
            trailing: const Text('Change', style: TextStyle(color: Color(0xFFD3A877))),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  String updatedAddress = address ?? '';
                  return AlertDialog(
                    title: const Text('Change Address'),
                    content: TextFormField(
                      initialValue: address,
                      onChanged: (value) {
                        updatedAddress = value;
                      },
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _changeAddress(updatedAddress);
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  );
                },
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.logout_sharp),
            title: const Text('L O G O U T'),
            //trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Implement logout logic here
            },
          ),
        ],
      ),
    );
  }
}
