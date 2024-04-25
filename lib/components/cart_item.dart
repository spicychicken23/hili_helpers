class CartItem {
  final String foodId;
  final String shopId;
  int quantity;
  double subtotal;

  CartItem({
    required this.foodId,
    required this.shopId,
    required this.quantity,
    required this.subtotal,
  });
}
