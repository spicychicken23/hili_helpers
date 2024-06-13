// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hili_helpers/components/services.dart';
import 'package:hili_helpers/models/cart.dart';
import 'package:hili_helpers/models/menu.dart';
import 'package:hili_helpers/pages/helper_orders_page.dart';
import 'package:hili_helpers/pages/helper_stocks_page.dart';
import 'package:hili_helpers/services/database_service.dart';
import 'package:intl/intl.dart';

class Selected extends StatefulWidget {
  final IconData icon;
  final String label;
  final String isEnd;
  final VoidCallback onTap;

  const Selected({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isEnd,
  }) : super(key: key);

  @override
  _SelectedState createState() => _SelectedState();
}

class _SelectedState extends State<Selected> {
  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius;
    if (widget.isEnd == 'Right') {
      borderRadius = const BorderRadius.only(
        topRight: Radius.circular(10),
        bottomRight: Radius.circular(10),
      );
    } else if (widget.isEnd == 'Left') {
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(10),
        bottomLeft: Radius.circular(10),
      );
    } else {
      borderRadius = BorderRadius.circular(0);
    }

    return Expanded(
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.all(5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFdbc1ac),
            borderRadius: borderRadius,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                widget.icon,
                color: const Color(0xff38220f),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: const TextStyle(
                  color: Color(0xff38220f),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HelperNaviBar extends StatefulWidget {
  const HelperNaviBar({super.key});

  @override
  _HelperNaviBarState createState() => _HelperNaviBarState();
}

class _HelperNaviBarState extends State<HelperNaviBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          Selected(
            icon: Icons.bar_chart_rounded,
            label: "Orders",
            isEnd: 'Left',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelperOrdersPage()),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Container(color: Colors.black, width: 2),
          ),
          Selected(
            icon: Icons.money_rounded,
            label: "Stocks",
            isEnd: 'Right',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelperStocksPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class shopStatus extends StatefulWidget {
  const shopStatus({super.key});

  @override
  State<shopStatus> createState() => _shopStatusState();
}

class _shopStatusState extends State<shopStatus> {
  late bool light;

  @override
  void initState() {
    super.initState();
    _fetchShopStatus();
  }

  Future<void> _fetchShopStatus() async {
    bool? shopStatus = await DatabaseService().getShopStatus();
    setState(() {
      light = shopStatus ?? false;
    });
  }

  Widget build(BuildContext context) {
    return FutureBuilder<bool?>(
      future: DatabaseService().getShopStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Switch(
            value: snapshot.data ?? false,
            activeColor: Colors.green,
            onChanged: (bool value) {
              setState(() {
                light = value;
                DatabaseService().toggleShopStatus(value);
                _fetchShopStatus();
              });
            },
          );
        }
      },
    );
  }
}

class statsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const statsCard(
      {super.key,
      required this.icon,
      required this.title,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, size: 30),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PopularItems extends StatelessWidget {
  const PopularItems({Key? key, this.sales, this.quantities}) : super(key: key);
  final double? sales;
  final int? quantities;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseService().getTopProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Map<String, dynamic>>? topItems = snapshot.data;
          if (topItems == null || topItems.isEmpty) {
            return const Text('No top products available.');
          } else {
            return Column(
              children: topItems.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> item = entry.value;
                return Column(
                  children: [
                    ListTile(
                      leading: Text(
                        (index + 1).toString(),
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      title: Text(
                        item['itemName'],
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Quantity sold: ${item['quantity']}",
                            style: const TextStyle(
                              fontSize: 8,
                            ),
                          ),
                          Text(
                            "[${((item['quantity'] / quantities) * 100).toStringAsFixed(0)} %]",
                            style: const TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Total sales: ${item['total'].toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 8,
                            ),
                          ),
                          Text(
                            "[${((item['total'] / sales) * 100).toStringAsFixed(0)} %]",
                            style: const TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            );
          }
        }
      },
    );
  }
}

class ShopRatings extends StatelessWidget {
  const ShopRatings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: DatabaseService().fetchFnbRatingsByOwner(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<String>? ratings = snapshot.data;
          if (ratings != null && ratings.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        ratings[0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${ratings[1]} Raters',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'DM Sans',
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      ratingBar(
                          '5',
                          int.parse(ratings[2]) == 0
                              ? 0
                              : int.parse(ratings[2]) / int.parse(ratings[1])),
                      ratingBar(
                          '4',
                          int.parse(ratings[3]) == 0
                              ? 0
                              : int.parse(ratings[3]) / int.parse(ratings[1])),
                      ratingBar(
                          '3',
                          int.parse(ratings[4]) == 0
                              ? 0
                              : int.parse(ratings[4]) / int.parse(ratings[1])),
                      ratingBar(
                          '2',
                          int.parse(ratings[5]) == 0
                              ? 0
                              : int.parse(ratings[5]) / int.parse(ratings[1])),
                      ratingBar(
                          '1',
                          int.parse(ratings[6]) == 0
                              ? 0
                              : int.parse(ratings[6]) / int.parse(ratings[1])),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return const Text('No ratings data available.');
          }
        }
      },
    );
  }
}

class StocksListing extends StatelessWidget {
  StocksListing({
    Key? key,
    required this.menu,
    required this.shopId,
  }) : super(key: key);

  final Menu menu;
  final String shopId;
  final DatabaseService _databaseService = DatabaseService();

  void _deleteStock(BuildContext context) {
    DatabaseService().deleteStock(menu.ID);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Stock deleted'),
      ),
    );
  }

  Future<void> _editStock(BuildContext context) async {
    print(menu.ID);
    // print(_databaseService.fetchMenuItemDataByShopId(menu.Shop_ID)); NOTES HERE
    // whenever try to call the firestoredatabase make sure call it in await statement
    Map<String, dynamic>? listMenu =
        await _databaseService.fetchMenuItemDataByShopId(menu.ID);

    print(listMenu);
    if (listMenu != null) {
      showDialog(
        context: context,
        builder: (context) {
          TextEditingController descriptionController =
              TextEditingController(text: listMenu['Description']);
          TextEditingController idController =
              TextEditingController(text: listMenu['ID']);
          TextEditingController iconController =
              TextEditingController(text: listMenu['Icon']);
          TextEditingController nameController =
              TextEditingController(text: listMenu['Name']);
          TextEditingController priceController =
              TextEditingController(text: listMenu['Price'].toString());
          TextEditingController shopIdController =
              TextEditingController(text: listMenu['Shop_ID']);
          TextEditingController inStockController =
              TextEditingController(text: listMenu['inStock'].toString());

          return AlertDialog(
            title: Center(
                child: Text('Edit Stock',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  style: TextStyle(),
                  controller: idController,
                  decoration: InputDecoration(labelText: 'ID'),
                ),
                TextField(
                  controller: iconController,
                  decoration: InputDecoration(labelText: 'Icon'),
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                ),
                TextField(
                  controller: shopIdController,
                  decoration: InputDecoration(labelText: 'Shop ID'),
                  readOnly: true,
                ),
                TextField(
                  controller: inStockController,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: 'In Stock',
                      suffixIcon: Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Text(
                            'true/false only',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ))),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () async {
                  //save action here
                  Map<String, dynamic> updatedData = {
                    'Description': descriptionController.text,
                    'ID': idController.text,
                    'Icon': iconController.text,
                    'Name': nameController.text,
                    'Price': double.tryParse(priceController.text) ?? 0,
                    'Shop_ID': shopIdController.text,
                    'inStock': bool.tryParse(inStockController.text) ?? 0,
                  };

                  // Call the updateMenuItem function
                  await _databaseService.updateMenuItem(
                      listMenu['ID'], updatedData);
                  // Close the dialog
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Save',
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      );
      // Use the controllers as needed
    } else {
      // Handle the case where no data was found or an error occurred
      print('No data found for Shop_ID: ${menu.Shop_ID}');
    }
  }

  void _confirmEdit(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Edit'),
          content: const Text('Are you sure you want to edit this stock?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _editStock(context);
              },
              child: const Text(
                'Edit',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this stock?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteStock(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (menu.Shop_ID != shopId) {
      return Container();
    }

    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            Row(children: [
              GestureDetector(
                onTap: () => _confirmEdit(context),
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFFdbc1ac),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(2),
                    child: Icon(Icons.edit,
                        color: Color.fromARGB(255, 83, 59, 38)),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () => _confirmDelete(context),
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFFdbc1ac),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(2),
                    child: Icon(Icons.delete_rounded,
                        color: Color.fromARGB(255, 83, 59, 38)),
                  ),
                ),
              ),
              const Spacer(),
              ItemStatus(itemId: menu.ID),
            ]),
            ListTile(
              leading: ClipOval(
                child: Image.network(
                  menu.Icon,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                menu.Name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Row(
                children: [
                  Text(
                    menu.Description,
                    style: const TextStyle(
                      fontSize: 8,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
              ),
              trailing: Column(
                children: [
                  Text(
                    'RM${menu.Price}',
                    style: const TextStyle(
                      color: Color(0xFFB3B3B3),
                      fontSize: 10,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}

class ItemStatus extends StatefulWidget {
  const ItemStatus({super.key, required this.itemId});
  final String itemId;

  @override
  State<ItemStatus> createState() => _ItemStatusState();
}

class _ItemStatusState extends State<ItemStatus> {
  late bool light;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchItemStatus();
  }

  Future<void> _fetchItemStatus() async {
    bool? itemStatus = await DatabaseService().getStockStatus(widget.itemId);
    if (mounted) {
      setState(() {
        light = itemStatus ?? false;
        isLoading = false;
      });
    }
  }

  void _toggleItemStatus(bool value) async {
    if (mounted) {
      setState(() {
        light = value;
      });
    }
    await DatabaseService().toggleStockStatus(value, widget.itemId);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const CircularProgressIndicator();
    }
    return Transform.scale(
      scale: 0.7,
      child: Switch(
        value: light,
        activeColor: Colors.green,
        onChanged: (bool value) {
          _toggleItemStatus(value);
        },
      ),
    );
  }
}

class ordersActive extends StatelessWidget {
  const ordersActive({
    Key? key,
    required this.order,
    required this.databaseService,
    double? rating,
  }) : super(key: key);

  final cart order;
  final DatabaseService databaseService;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          InkWell(
            onTap: () async {
              List<Map<String, dynamic>> customerDetails =
                  await DatabaseService()
                      .fetchCustomersById(order.customer_Id!);
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Customer Details'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: customerDetails.map((detail) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Name: ${detail['name']}'),
                            const SizedBox(height: 20),
                            Text('Address: ${detail['address']}'),
                            const SizedBox(
                              height: 20,
                            ),
                            Text('Phone: ${detail['phoneNumber']}'),
                          ],
                        );
                      }).toList(),
                    ),
                    actions: [
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              DatabaseService().updateStatus(order.cart_Id!);
                              Navigator.of(context).pop();
                            },
                            child: const Text('Complete',
                                style: TextStyle(color: Colors.green)),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Close',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      )
                    ],
                  );
                },
              );
            },
            child: ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(_getIcon(order.order_date)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                order.order_date.toDate().toString(),
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
              subtitle: FutureBuilder<List<Map<String, dynamic>>>(
                future: databaseService.fetchItemsByRandomId(order.randomId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text(
                      'No items found',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                  List<Map<String, dynamic>> items = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: items.map((item) {
                      return Text(
                        '${item['itemName']} - ${item['quantity']}',
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              trailing: Text(
                'RM ${order.subtotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 8,
                ),
              ),
            ),
          ),
          const Divider(
            thickness: 1,
          ),
        ],
      ),
    );
  }
}

String _getIcon(Timestamp date) {
  Timestamp now = Timestamp.now();

  DateTime dateTime = date.toDate();
  DateTime nowDateTime = now.toDate();

  String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
  String formattedNowDate = DateFormat('yyyy-MM-dd').format(nowDateTime);

  if (formattedDate == formattedNowDate) {
    return 'lib/images/On Going.png';
  } else if (dateTime.isAfter(nowDateTime)) {
    return 'lib/images/Upcoming.png';
  } else {
    return 'lib/images/Missed.png';
  }
}
