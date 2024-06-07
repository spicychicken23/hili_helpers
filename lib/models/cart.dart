import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hili_helpers/models/cart_item.dart';

class cart {
  List<CartItem> items;
  Timestamp order_date;
  int quantity;
  String shop_Id;
  String status;
  double subtotal;
  int randomId;
  String? customer_Id;
  String? cart_Id;

  cart({
    required this.items,
    required this.order_date,
    required this.quantity,
    required this.shop_Id,
    required this.status,
    required this.subtotal,
    required this.randomId,
    this.customer_Id,
    this.cart_Id,
  });

  cart.fromJson(Map<String, dynamic> json)
      : this(
          items: [],
          order_date: json['order_date'] as Timestamp,
          quantity: json['quantity'] as int,
          shop_Id: json['shop_Id'] as String,
          status: json['status'] as String,
          subtotal: json['total'] as double,
          randomId: json['random-Id'] as int,
          customer_Id: json['customer_Id'] as String,
          cart_Id: json['cart_Id'] as String,
        );

  Map<String, dynamic> toJson() {
    return {
      'order_date': order_date,
      'quantity': quantity,
      'shop_Id': shop_Id,
      'status': status,
      'subtotal': subtotal,
      'random-Id': randomId,
    };
  }

  Future<void> saveItems(userId) async {
    CollectionReference<Map<String, dynamic>> itemsCollection =
        FirebaseFirestore.instance.collection('Items');

    for (var i = 0; i < items.length; i++) {
      await itemsCollection.doc('${userId}_${items[i].randomid}_$i').set({
        'ownerId': userId,
        'itemName': items[i].name,
        'quantity': items[i].quantity,
        'total': items[i].subtotal,
      });
    }
  }
}
