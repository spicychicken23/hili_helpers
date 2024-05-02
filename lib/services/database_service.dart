import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hili_helpers/models/cart.dart';
import 'package:hili_helpers/models/promo.dart';
import 'package:hili_helpers/models/fnbLists.dart';
import 'package:hili_helpers/models/menu.dart';
import 'package:hili_helpers/models/cart_item.dart';

//const String PROMO_COLLECTION_REF = 'Promo';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late final CollectionReference _promoRef;
  late final CollectionReference _fnbListsRef;
  late final CollectionReference _menuListsRef;

  DatabaseService() {
    _promoRef = _firestore.collection('Promo');
    _fnbListsRef = _firestore.collection('fnbLists');
    _menuListsRef = _firestore.collection('Menu');
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

      Map<String, dynamic> data = {
        'name': cartItem.name,
        'customer_Id': userId,
        'food_Id': cartItem.foodId,
        'shop_Id': cartItem.shopId,
        'order_Id': orderId,
        'subtotal': cartItem.subtotal,
        'quantity': cartItem.quantity,
        'order_date': orderDate,
        'status': 'On Going',
        'random_id': cartItem.randomid,
      };

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
}
