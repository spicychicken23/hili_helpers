import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddMenuItemPage extends StatefulWidget {
  final String shopId;

  const AddMenuItemPage({Key? key, required this.shopId}) : super(key: key);

  @override
  _AddMenuItemPageState createState() => _AddMenuItemPageState();
}

class _AddMenuItemPageState extends State<AddMenuItemPage> {
  final _formKey = GlobalKey<FormState>();
  String _itemName = '';
  String _itemDescription = '';
  double _itemPrice = 0.0;
  final String _itemIcon =
      'https://drive.usercontent.google.com/download?id=1YH1ek_Zo6bNo74so1Nr5c4KQRkoPQjIx';
  final bool _inStock = true;
  late String _generatedId;

  @override
  void initState() {
    super.initState();
    _generateId();
  }

  void _generateId() {
    String serviceType = widget.shopId[0].toUpperCase();
    String randomNumber = (100 + UniqueKey().hashCode % 900).toString();
    _generatedId = serviceType + randomNumber;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FirebaseFirestore.instance.collection('Menu').add({
        'Description': _itemDescription,
        'ID': _generatedId,
        'Icon': _itemIcon,
        'Name': _itemName,
        'Price': _itemPrice,
        'Shop_ID': widget.shopId,
        'inStock': _inStock,
      }).then((value) {
        Navigator.pop(context);
      }).catchError((error) {
        print("Failed to add item: $error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE4E6ED),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 50),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Text(
                      'Add Menu Item',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: _generatedId,
                  decoration: const InputDecoration(
                    labelText: 'ID',
                    labelStyle: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the item name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _itemName = value!;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the item description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _itemDescription = value!;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    labelStyle: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the item price';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _itemPrice = double.parse(value!);
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: widget.shopId,
                  decoration: const InputDecoration(
                    labelText: 'Shop ID',
                    labelStyle: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      'Add Item',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
