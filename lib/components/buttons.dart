import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hili_helpers/models/promo.dart';
import 'package:hili_helpers/models/fnbLists.dart';
import 'package:hili_helpers/models/menu.dart';
import 'package:hili_helpers/pages/FNB_Details_page.dart';
import 'package:hili_helpers/components/cart_item.dart';
import 'package:hili_helpers/services/database_service.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.buttonText,
      this.isOutlined = false,
      required this.onPressed,
      this.width = 280});

  final String buttonText;
  final bool isOutlined;
  final Function onPressed;
  final double width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Material(
        borderRadius: BorderRadius.circular(30),
        elevation: 4,
        child: Container(
          width: 330,
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: isOutlined ? Colors.white : const Color(0xFF2367B1),
            border: Border.all(color: const Color(0xFF2367B1), width: 1.5),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: isOutlined ? const Color(0xFF2367B1) : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget accBtn(String image, BuildContext context, String nextPageId) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, nextPageId);
    },
    child: AspectRatio(
      aspectRatio: 2.62 / 3,
      child: Container(
        margin: const EdgeInsets.only(right: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(image),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              stops: const [0.1, 0.9],
              colors: [
                const Color(0xFF0C171D).withOpacity(.4),
                const Color(0xFF0C171D).withOpacity(.1),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget allBtn(IconData icon, String label, VoidCallback onPressed) {
  return InkWell(
    onTap: () {},
    child: Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
          child: IconButton(
            icon: Icon(icon),
            onPressed: onPressed,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        /* 
          Text(
            label,
            style: TextStyle(color: Colors.blue),
          ),
          */
      ],
    ),
  );
}

class NewsPromo extends StatelessWidget {
  //const NewsPromo({super.key});
  const NewsPromo({super.key, required this.promo});
  final Promo promo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
              radius: 25,
            ),
            title: Text(
              promo.Title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              promo.Description,
              style: const TextStyle(
                fontSize: 8,
              ),
            ),
            //trailing: Text('F&B'),
          ),
          const Divider(
            thickness: 1,
          ),
        ],
      ),
    );
  }
}

// ignore: camel_case_types
class fnbListing extends StatelessWidget {
  const fnbListing({Key? key, required this.fnbs}) : super(key: key);

  final fnb fnbs;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NextPage(Fnb: fnbs),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            ListTile(
              // ignore: unnecessary_null_comparison
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
                fnbs.Category,
                style: const TextStyle(
                  color: Color(0xFFB3B3B3),
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class menuListing extends StatelessWidget {
  const menuListing({Key? key, required this.menu, required this.shopId})
      : super(key: key);

  final Menu menu;
  final String shopId;

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
                  fontSize: 20,
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
                  SizedBox(
                    width: 70,
                    height: 30,
                    child: Quantity(
                        food_id: menu.ID,
                        shop_id: shopId,
                        initialSubtotal: menu.Price),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Quantity extends StatefulWidget {
  const Quantity(
      {Key? key,
      this.initialQuantity = 0,
      required this.initialSubtotal,
      required this.food_id,
      required this.shop_id})
      : super(key: key);

  final int initialQuantity;
  final double initialSubtotal;
  final String food_id;
  final String shop_id;

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
    _subtotal = widget.initialSubtotal;
    _databaseService = DatabaseService();
  }

  void _incrementQuantity() {
    setState(() {
      _subtotal += _subtotal;
      _quantity++;
      _updateCart();
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 0) {
        _subtotal -= _subtotal;
        _quantity--;
        _updateCart();
      }
    });
  }

  void _updateCart() {
    if (_quantity > 0) {
      final cartItem = CartItem(
        foodId: widget.food_id,
        shopId: widget.shop_id,
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
                style: const TextStyle(fontSize: 6),
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
                      color: Color(0xFFD3A877),
                      icon: Icon(Icons.add),
                      iconSize: 12,
                      onPressed: _incrementQuantity,
                    ),
                  )
                : IconButton(
                    color: Color(0xFFD3A877),
                    icon: Icon(Icons.add),
                    iconSize: 12,
                    onPressed: _incrementQuantity,
                  ),
          ),
        ),
      ],
    );
  }
}
