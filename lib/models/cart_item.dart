import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String name;
  final String foodId;
  final String shopId;
  final int randomid;
  int quantity;
  double subtotal;

  CartItem({
    required this.name,
    required this.foodId,
    required this.shopId,
    required this.randomid,
    required this.quantity,
    required this.subtotal,
  });

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
    };
  }
}
