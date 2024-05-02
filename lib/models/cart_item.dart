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

  static fromJson(item) {}
}
