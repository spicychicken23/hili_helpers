// ignore: unused_import
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
  cart({
    required this.items,
    required this.order_date,
    required this.quantity,
    required this.shop_Id,
    required this.status,
    required this.subtotal,
    required this.randomId,
  });

  cart.fromJson(Map<String, Object?> json)
      : this(
          items: json['items']! as List<CartItem>,
          order_date: json['order_date']! as Timestamp,
          quantity: json['quantity']! as int,
          shop_Id: json['shop_Id']! as String,
          status: json['status']! as String,
          subtotal: json['subtotal']! as double,
          randomId: json['random_id']! as int,
        );

  Map<String, dynamic> toJson() {
    return {
      'items': items,
      'order_date': order_date,
      'quantity': quantity,
      'shop_Id': shop_Id,
      'status': status,
      'subtotal': subtotal
    };
  }
}
