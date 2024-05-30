import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toggle_switch/toggle_switch.dart';

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
  String _itemIcon = '';
  bool _inStock = true;
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
      backgroundColor: Color(0xFFE4E6ED),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_left),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      'Add Menu Item',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: _generatedId,
                  decoration: InputDecoration(
                    labelText: 'ID',
                    labelStyle: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  readOnly: true,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
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
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
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
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
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
                SizedBox(height: 16),
                TextFormField(
                  initialValue: widget.shopId,
                  decoration: InputDecoration(
                    labelText: 'Shop ID',
                    labelStyle: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  readOnly: true,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Icon',
                    labelStyle: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the item icon';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _itemIcon = value!;
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'In Stock',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    SizedBox(width: 10),
                    ToggleSwitch(
                      minWidth: 90.0,
                      cornerRadius: 20.0,
                      activeBgColors: [
                        [Colors.green[800]!],
                        [Colors.red[800]!]
                      ],
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Colors.white,
                      initialLabelIndex: _inStock ? 0 : 1,
                      totalSwitches: 2,
                      labels: ['True', 'False'],
                      radiusStyle: true,
                      onToggle: (index) {
                        setState(() {
                          _inStock = index == 0;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                  ),
                  child: Text(
                    'Add Item',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// TODO Implement this library.