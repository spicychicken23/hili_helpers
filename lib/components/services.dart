import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hili_helpers/models/cart.dart';
import 'package:hili_helpers/models/search.dart';
import 'package:hili_helpers/models/servicesLists.dart';
import 'package:hili_helpers/models/menu.dart';
import 'package:hili_helpers/pages/services_details_page.dart';
import 'package:hili_helpers/models/cart_item.dart';
import 'package:hili_helpers/services/database_service.dart';

// ignore: camel_case_types
class PageInfo {
  final Color color;
  final String title;
  final String disclaimer;
  final String heading;
  final String type;
  PageInfo(
      {required this.color,
      required this.title,
      required this.disclaimer,
      required this.heading,
      required this.type});
}

PageInfo getPageInfo(String pageType) {
  switch (pageType) {
    case 'FNB':
      return PageInfo(
          type: 'FNB',
          color: const Color(0xFFDB9439),
          title: 'Food and Beverages',
          disclaimer: '',
          heading: 'Menu');
    case 'EDU':
      return PageInfo(
          type: 'EDU',
          color: const Color(0xFF38b6ff),
          title: 'Educational classes',
          disclaimer: '*All orders should be make 1 week prior to class',
          heading: 'Offered classes');
    case 'DOM':
      return PageInfo(
          type: 'DOM',
          color: const Color(0xFFff5757),
          title: 'Domestic services',
          disclaimer: '*All prices are only consultation fees',
          heading: 'Offered services');
    case 'VEH':
      return PageInfo(
          type: 'VEH',
          color: const Color(0xFFff914d),
          title: 'Vehicles Care',
          disclaimer: '*All prices are only consultation fees',
          heading: 'Offered services');
    default:
      return PageInfo(
        type: '',
        color: const Color(0xFF38b6ff),
        title: 'Unknown',
        disclaimer: '',
        heading: '',
      );
  }
}

class servicesListing extends StatelessWidget {
  const servicesListing({Key? key, required this.fnbs}) : super(key: key);
  final fnb fnbs;

  @override
  Widget build(BuildContext context) {
    bool isOpen = fnbs.open;

    return IgnorePointer(
      ignoring: !isOpen,
      child: GestureDetector(
        onTap: isOpen
            ? () {
                String pageType = fnbs.ID.substring(0, 3);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FnbDetailsPage(Fnb: fnbs, pageType: pageType),
                  ),
                );
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              ListTile(
                tileColor: isOpen ? null : Color.fromARGB(35, 56, 34, 15),
                leading: ClipOval(
                  child: Image.network(
                    fnbs.Icon,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  fnbs.Name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 12,
                      color: Color(0xFFD3A877),
                    ),
                    Text(
                      fnbs.Rating.toString(),
                      style: const TextStyle(
                        fontSize: 8,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
                trailing: Text(
                  isOpen ? fnbs.Category : 'CLOSED',
                  style: const TextStyle(
                    color: Color(0xFFB3B3B3),
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class menuListing extends StatelessWidget {
  const menuListing({
    Key? key,
    required this.menu,
    required this.shopId,
    required this.randomId,
    required this.updateTotalQuantity,
  }) : super(key: key);

  final Menu menu;
  final String shopId;
  final int randomId;
  final Function(int, bool) updateTotalQuantity;

  @override
  Widget build(BuildContext context) {
    bool isAvailable = menu.inStock;

    if (menu.Shop_ID != shopId) {
      return Container();
    }

    return IgnorePointer(
      ignoring: !isAvailable,
      child: GestureDetector(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              ListTile(
                tileColor: isAvailable ? null : Color.fromARGB(35, 56, 34, 15),
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
                trailing: isAvailable
                    ? Column(
                        children: [
                          SizedBox(
                            width: 70,
                            height: 30,
                            child: Quantity(
                              name: menu.Name,
                              food_id: menu.ID,
                              shop_id: shopId,
                              initialSubtotal: menu.Price,
                              randomid: randomId,
                              updateTotalQuantity: updateTotalQuantity,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'RM${menu.Price}',
                            style: const TextStyle(
                              color: Color(0xFFB3B3B3),
                              fontSize: 10,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
                      )
                    : const Text(
                        'UNAVAILABLE',
                        style: TextStyle(
                          color: Color(0xFFB3B3B3),
                          fontFamily: 'Roboto',
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Quantity extends StatefulWidget {
  const Quantity(
      {Key? key,
      this.initialQuantity = 0,
      required this.name,
      required this.initialSubtotal,
      required this.food_id,
      required this.shop_id,
      required this.randomid,
      required this.updateTotalQuantity})
      : super(key: key);

  final int initialQuantity;
  final double initialSubtotal;
  final String name;
  final String food_id;
  final String shop_id;
  final int randomid;
  final Function(int, bool) updateTotalQuantity;

  @override
  _QuantityState createState() => _QuantityState();
}

class _QuantityState extends State<Quantity> {
  late int _quantity;
  late double _subtotal;
  late DatabaseService _databaseService;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity;
    _subtotal = 0;
    _databaseService = DatabaseService();
  }

  void _incrementQuantity() {
    setState(() {
      _subtotal += widget.initialSubtotal;
      _quantity++;
      _updateCart();
      widget.updateTotalQuantity(1, true);
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 0) {
        _subtotal -= widget.initialSubtotal;
        _quantity--;
        _updateCart();
        widget.updateTotalQuantity(1, false);
      }
    });
  }

  void _updateCart() {
    if (_quantity > 0) {
      final cartItem = CartItem(
        name: widget.name,
        foodId: widget.food_id,
        shopId: widget.shop_id,
        randomid: widget.randomid,
        quantity: _quantity,
        subtotal: _subtotal,
      );
      _databaseService.addToCart(cartItem);
    } else {
      _databaseService.deleteCartItem(widget.food_id, widget.shop_id);
    }
  }

  @override
  void dispose() {
    _databaseService.deleteCartItem(widget.food_id, widget.shop_id);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_quantity > 0)
          SizedBox(
            width: 25,
            height: 25,
            child: Center(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(10),
                  ),
                ),
                child: IconButton(
                  color: const Color(0xFFD3A877),
                  icon: const Icon(Icons.remove),
                  iconSize: 12,
                  onPressed: _decrementQuantity,
                ),
              ),
            ),
          ),
        if (_quantity > 0)
          SizedBox(
            width: 20,
            height: 20,
            child: Center(
              child: Text(
                '$_quantity',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        if (_quantity == 0) const SizedBox(width: 25),
        SizedBox(
          width: 25,
          height: 25,
          child: Center(
            child: _quantity > 0
                ? DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(10),
                      ),
                    ),
                    child: IconButton(
                      color: const Color(0xFFD3A877),
                      icon: const Icon(Icons.add),
                      iconSize: 12,
                      onPressed: _incrementQuantity,
                    ),
                  )
                : IconButton(
                    color: const Color(0xFFD3A877),
                    icon: const Icon(Icons.add),
                    iconSize: 12,
                    onPressed: _incrementQuantity,
                  ),
          ),
        ),
      ],
    );
  }
}

class ConfirmOrder extends StatefulWidget {
  final String shop_Id;
  final int random_Id;

  const ConfirmOrder({
    Key? key,
    required this.shop_Id,
    required this.random_Id,
  }) : super(key: key);

  @override
  _ConfirmOrderState createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  List<CartItem> items = [];
  int quantity = 0;
  double subtotal = 0.0;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  void fetchCartItems() async {
    try {
      final QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
          .collection('Cart')
          .where('shop_Id', isEqualTo: widget.shop_Id)
          .where('random_id', isEqualTo: widget.random_Id)
          .get();

      if (cartSnapshot.docs.isNotEmpty) {
        cartSnapshot.docs.forEach((doc) {
          final cartData = doc.data() as Map<String, dynamic>;
          final CartItem cartItem = CartItem(
            name: cartData['name'],
            foodId: cartData['food_Id'],
            shopId: cartData['shop_Id'],
            randomid: cartData['random_id'],
            quantity: cartData['quantity'],
            subtotal: cartData['subtotal'],
            rated: cartData['Rated'],
          );
          items.add(cartItem);
          setState(() {
            quantity += cartItem.quantity;
            subtotal += cartItem.subtotal;
          });
        });
      }
    } catch (error) {
      print('Error fetching cart items: $error');
    }
  }

  void _confirmOrder() {
    final newCart = cart(
      items: items,
      order_date: Timestamp.now(),
      quantity: quantity,
      shop_Id: widget.shop_Id,
      status: "On Going",
      subtotal: subtotal,
      randomId: widget.random_Id,
    );
    DatabaseService().addToCartList(newCart);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFE4E6ED),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: const Color(0xFFDB9439),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              height: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.chevron_left),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Confirm Order",
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'DM Sans',
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Total Items: $quantity',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Total Price: RM${subtotal.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Items Ordered:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                            '${items[index].name} x ${items[index].quantity}'),
                        subtitle: Text('[${items[index].foodId}]'),
                        trailing: Text(
                            'RM ${items[index].subtotal.toStringAsFixed(2)}'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _confirmOrder();
          int count = 0;
          Navigator.popUntil(context, (route) {
            return count++ == 3;
          });
        },
        backgroundColor: const Color(0xFF5CB85C),
        foregroundColor: const Color(0xFFFFFFFF),
        label: const Text("Confirm"),
      ),
    );
  }
}

Widget ratingBar(String label, double value) {
  return Row(
    children: [
      Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFamily: 'DM Sans',
        ),
      ),
      const SizedBox(width: 8),
      SizedBox(
        height: 5,
        width: 100,
        child: LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(
            Color(0xFFD3A877),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
      ),
    ],
  );
}

class SpecificSearchBar extends SearchDelegate {
  SpecificSearchBar({Key? key, required this.shopType}) {
    searchTerms = DatabaseService().fetchSpecificSearchTerms(shopType);
  }

  final String shopType;
  late List<Shop> searchTerms;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Shop>>(
      future: fetchFilteredShops(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Shop> matchQuery = snapshot.data ?? [];
          return ListView.builder(
            itemCount: matchQuery.length,
            itemBuilder: (context, index) {
              var result = matchQuery[index];
              return GestureDetector(
                onTap: () async {
                  fnb? fetchedFnb =
                      await DatabaseService().fetchFnbByShopId(result.id);
                  String pageType = result.id.substring(0, 3);
                  if (fetchedFnb != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FnbDetailsPage(Fnb: fetchedFnb, pageType: pageType),
                      ),
                    );
                  }
                },
                child: ListTile(
                  title: Text(result.name),
                ),
              );
            },
          );
        }
      },
    );
  }

  Future<List<Shop>> fetchFilteredShops(String query) async {
    List<Shop> filteredShops = searchTerms
        .where((shop) => shop.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return filteredShops;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Shop>>(
      future: fetchFilteredShops(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Shop> matchQuery = snapshot.data ?? [];
          return ListView.builder(
            itemCount: matchQuery.length,
            itemBuilder: (context, index) {
              var result = matchQuery[index];
              return GestureDetector(
                onTap: () async {
                  fnb? fetchedFnb =
                      await DatabaseService().fetchFnbByShopId(result.id);
                  String pageType = result.id.substring(0, 3);
                  if (fetchedFnb != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FnbDetailsPage(Fnb: fetchedFnb, pageType: pageType),
                      ),
                    );
                  }
                },
                child: ListTile(
                  title: Text(result.name),
                ),
              );
            },
          );
        }
      },
    );
  }
}
