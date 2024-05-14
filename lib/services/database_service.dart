import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hili_helpers/models/cart.dart';
import 'package:hili_helpers/models/promo.dart';
import 'package:hili_helpers/models/fnbLists.dart';
import 'package:hili_helpers/models/menu.dart';
import 'package:hili_helpers/models/cart_item.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late final CollectionReference _promoRef;
  late final CollectionReference _fnbListsRef;
  late final CollectionReference _menuListsRef;
  late final CollectionReference _cartListsRef;

  DatabaseService() {
    _promoRef = _firestore.collection('Promo');
    _fnbListsRef = _firestore.collection('fnbLists');
    _menuListsRef = _firestore.collection('Menu');
    _cartListsRef = _firestore.collection('CartList');
  }

  Stream<List<Promo>> getPromo() {
    return _promoRef
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((doc) {
              return Promo.fromJson(doc.data() as Map<String, dynamic>);
            }).toList());
  }

  Stream<List<fnb>> getFnbLists() {
    return _fnbListsRef
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((doc) {
              return fnb.fromJson(doc.data() as Map<String, dynamic>);
            }).toList());
  }

  Stream<List<Menu>> getMenuLists() {
    return _menuListsRef
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((doc) {
              return Menu.fromJson(doc.data() as Map<String, dynamic>);
            }).toList());
  }

  Future<void> addToCart(CartItem cartItem) async {
    String? userId = _auth.currentUser?.uid;

    if (userId != null) {
      String orderId = _firestore.collection('Cart').doc().id;
      Timestamp orderDate = Timestamp.now();

      Map<String, dynamic> data = cartItem.toMap(userId, orderId, orderDate);

      await _firestore
          .collection('Cart')
          .doc('${cartItem.foodId}_${cartItem.shopId}')
          .set(data);
    } else {
      print('Mu hacker ke? Tlg la jangan.');
    }
  }

  Future<void> updateCartItemQuantity(CartItem cartItem) {
    return _firestore
        .collection('Cart')
        .doc('${cartItem.foodId}_${cartItem.shopId}')
        .update({
      'quantity': cartItem.quantity,
    });
  }

  Future<void> deleteCartItem(String foodId, String shopId) {
    return _firestore.collection('Cart').doc('${foodId}_${shopId}').delete();
  }

  Future<String?> getUsersName() async {
    String? userId = _auth.currentUser?.uid;
    if (userId != null) {
      try {
        DocumentSnapshot userSnapshot =
            await _firestore.collection('users').doc(userId).get();

        if (userSnapshot.exists) {
          Map<String, dynamic>? userData =
              userSnapshot.data() as Map<String, dynamic>?;

          if (userData != null) {
            String? userName = userData['name'] as String?;
            if (userName != null) {
              return userName;
            } else {
              print('User name is null.');
            }
          } else {
            print('User data is null.');
          }
        } else {
          print('User document does not exist.');
        }
      } catch (error) {
        print('Error fetching user data: $error');
      }
    } else {
      print('User not logged in.');
    }
    return null;
  }

  Future<String?> getStatus() async {
    String? userId = _auth.currentUser?.uid;
    if (userId != null) {
      try {
        DocumentSnapshot userSnapshot =
            await _firestore.collection('users').doc(userId).get();

        if (userSnapshot.exists) {
          Map<String, dynamic>? userData =
              userSnapshot.data() as Map<String, dynamic>?;

          if (userData != null) {
            String? userName = userData['status'] as String?;
            if (userName != null) {
              return userName;
            } else {
              print('User name is null.');
            }
          } else {
            print('User data is null.');
          }
        } else {
          print('User document does not exist.');
        }
      } catch (error) {
        print('Error fetching user data: $error');
      }
    } else {
      print('User not logged in.');
    }
    return null;
  }

  Future<void> addToCartList(cart newCart) async {
    String? userId = _auth.currentUser?.uid;

    if (userId != null) {
      String cartId = _firestore.collection('CartList').doc().id;

      Map<String, dynamic> data = {
        'customer_Id': userId,
        'cart_Id': cartId,
        'shop_Id': newCart.shop_Id,
        'total': newCart.subtotal,
        'quantity': newCart.quantity,
        'order_date': newCart.order_date,
        'status': newCart.status,
        'random-Id': newCart.randomId,
      };

      await _firestore
          .collection('CartList')
          .doc('${cartId}_$userId')
          .set(data);
    } else {
      print('Mu hacker ke? Tlg la jangan.');
    }
  }

  Stream<List<cart>> getCartCom() {
    return _cartListsRef
        .where('customer_Id', isEqualTo: _auth.currentUser?.uid)
        .where('status', isEqualTo: 'Completed')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((doc) {
              return cart.fromJson(doc.data() as Map<String, dynamic>);
            }).toList());
  }

  Stream<List<cart>> getCartAct() {
    return _cartListsRef
        .where('customer_Id', isEqualTo: _auth.currentUser?.uid)
        .where('status', isEqualTo: 'On Going')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((doc) {
              return cart.fromJson(doc.data() as Map<String, dynamic>);
            }).toList());
  }

  Future<String?> getShopName(String shopId) async {
    try {
      QuerySnapshot querySnapshot =
          await _fnbListsRef.where('ID', isEqualTo: shopId).get();

      if (querySnapshot.docs.isNotEmpty) {
        var shopData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        String? shopName = shopData['Name'] as String?;
        if (shopName != null) {
          return shopName;
        }
      } else {
        print('No shop found with ID: $shopId');
      }

      return 'Shop Name Not Found';
    } catch (error) {
      print('Error fetching shop data: $error');
      throw error;
    }
  }

  Future<fnb?> fetchFnbByShopId(String shopId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('fnb')
          .where('ID', isEqualTo: shopId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        return fnb.fromJson(doc.data() as Map<String, Object?>);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching fnb: $e');
      return null;
    }
  }

  Future<int> totalTransactions(String shopId, {DateTime? startDate, DateTime? endDate}) async {
    try {
      Query query = FirebaseFirestore.instance
          .collection('CartList')
          .where('shop_Id', isEqualTo: shopId);

      if (startDate != null && endDate != null) {
        query = query
            .where('timestamp', isGreaterThanOrEqualTo: startDate)
            .where('timestamp', isLessThanOrEqualTo: endDate);
      }

      AggregateQuerySnapshot querySnapshot = await query.count().get();

      return querySnapshot.count ?? 0;
    } catch (e) {
      print('Error counting transactions: $e');
      return 0;
    }
  }

  Future<int> totalSales(String shopId, {DateTime? startDate, DateTime? endDate}) async {
    try {
      Query query = FirebaseFirestore.instance
          .collection('CartList')
          .where('shop_Id', isEqualTo: shopId);

      if (startDate != null && endDate != null) {
        query = query
            .where('timestamp', isGreaterThanOrEqualTo: startDate)
            .where('timestamp', isLessThanOrEqualTo: endDate);
      }

      QuerySnapshot querySnapshot = await query.get();

      int totalSales = 0;

      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        totalSales += data['total'] as int? ?? 0;
      }

      return totalSales;
    } catch (e) {
      print('Error calculating total sales: $e');
      return 0;
    }
  }

  Future<int> totalQuantity(String shopId, {DateTime? startDate, DateTime? endDate}) async {
    try {
      Query query = FirebaseFirestore.instance
          .collection('CartList')
          .where('shop_Id', isEqualTo: shopId);

      if (startDate != null && endDate != null) {
        query = query
            .where('timestamp', isGreaterThanOrEqualTo: startDate)
            .where('timestamp', isLessThanOrEqualTo: endDate);
      }

      QuerySnapshot querySnapshot = await query.get();

      int totalQuantity = 0;

      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        totalQuantity += data['quantity'] as int? ?? 0;
      }

      return totalQuantity;
    } catch (e) {
      print('Error calculating total quantity: $e');
      return 0;
    }
  }
}

