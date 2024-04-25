// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';

class cart {
  String customer_Id;
  String food_Id;
  String order_Id;
  Timestamp order_date;
  int quantity;
  String shop_Id;
  String status;
  double subtotal;
  cart({
    required this.customer_Id,
    required this.food_Id,
    required this.order_Id,
    required this.order_date,
    required this.quantity,
    required this.shop_Id,
    required this.status,
    required this.subtotal,
  });

  cart.fromJson(Map<String, Object?> json)
      : this(
          customer_Id: json['customer_Id']! as String,
          food_Id: json['food_Id']! as String,
          order_Id: json['order_Id']! as String,
          order_date: json['order_date']! as Timestamp,
          quantity: json['quantity']! as int,
          shop_Id: json['shop_Id']! as String,
          status: json['status']! as String,
          subtotal: json['subtotal']! as double,
        );

  cart copyWith({
    String? customer_Id,
    String? food_Id,
    String? order_Id,
    Timestamp? order_date,
    int? quantity,
    String? shop_Id,
    String? status,
    double? subtotal,
  }) {
    return cart(
        customer_Id: customer_Id ?? this.customer_Id,
        food_Id: food_Id ?? this.food_Id,
        order_Id: order_Id ?? this.order_Id,
        order_date: order_date ?? this.order_date,
        quantity: quantity ?? this.quantity,
        shop_Id: shop_Id ?? this.shop_Id,
        status: status ?? this.status,
        subtotal: subtotal ?? this.subtotal);
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_Id': customer_Id,
      'food_Id': food_Id,
      'order_Id': order_Id,
      'order_date': order_date,
      'quantity': quantity,
      'shop_Id': shop_Id,
      'status': status,
      'subtotal': subtotal
    };
  }
}
