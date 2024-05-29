import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String name;
  final String foodId;
  final String shopId;
  final int randomid;
  int quantity;
  double subtotal;
  int? rated;

  CartItem({
    required this.name,
    required this.foodId,
    required this.shopId,
    required this.randomid,
    required this.quantity,
    required this.subtotal,
    this.rated,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      name: json['name'] as String,
      foodId: json['food_Id'] as String,
      shopId: json['shop_Id'] as String,
      randomid: json['random_id'] as int,
      quantity: json['quantity'] as int,
      subtotal: json['subtotal'] as double,
      rated: json['Rated'] as int?, // Mark rated as optional
    );
  }

  Map<String, dynamic> toMap(
      String userId, String orderId, Timestamp orderDate) {
    return {
      'name': name,
      'customer_Id': userId,
      'food_Id': foodId,
      'shop_Id': shopId,
      'order_Id': orderId,
      'subtotal': subtotal,
      'quantity': quantity,
      'order_date': orderDate,
      'status': 'On Going',
      'random_id': randomid,
      'Rated': rated,
    };
  }
}
