// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hili_helpers/models/cart.dart';
import 'package:hili_helpers/models/promo.dart';
import 'package:hili_helpers/models/servicesLists.dart';
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

  Stream<List<fnb>> getFnbLists(String type) {
    return _fnbListsRef
        .where('ID', isGreaterThanOrEqualTo: type)
        .where('ID', isLessThan: type + '\uf8ff')
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

      await newCart.saveItems(userId);
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

  Future<List<String>> fetchFnbRatingsByOwner() async {
    String? userId = _auth.currentUser?.uid;
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('fnbLists')
          .where('Owner', isEqualTo: userId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        List<String> ratings = [
          '${doc['Rating']}',
          '${doc['Raters']}',
          '${doc['Rate_1']}',
          '${doc['Rate_2']}',
          '${doc['Rate_2']}',
          '${doc['Rate_2']}',
          '${doc['Rate_2']}',
        ];
        return ratings;
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching fnb: $e');
      return [];
    }
  }

  Future<fnb?> fetchFnbByOwner() async {
    String? userId = _auth.currentUser?.uid;
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('fnb')
          .where('Owner', isEqualTo: userId)
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

  Future<double> totalSales({DateTime? startDate, DateTime? endDate}) async {
    String? userId = _auth.currentUser?.uid;
    String? shopId = await getShopId(userId!);

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

      double totalSales = 0;

      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        totalSales += data['total'] as double? ?? 0;
      }
      return totalSales;
    } catch (e) {
      print('Error calculating total sales: $e');
      return 0;
    }
  }

  Future<int> totalQuantity({DateTime? startDate, DateTime? endDate}) async {
    String? userId = _auth.currentUser?.uid;
    String? shopId = await getShopId(userId!);

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

  Future<int> totalTransaction() async {
    String? userId = _auth.currentUser?.uid;
    String? shopId = await getShopId(userId!);
    try {
      Query query = FirebaseFirestore.instance
          .collection('CartList')
          .where('shop_Id', isEqualTo: shopId);

      QuerySnapshot querySnapshot = await query.get();

      return querySnapshot.size;
    } catch (e) {
      print('Error calculating total transactions: $e');
      return 0;
    }
  }

  Future<String?> getShopId(String ownerId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('fnbLists')
          .where('Owner', isEqualTo: ownerId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;
        Map<String, dynamic>? userData =
            docSnapshot.data() as Map<String, dynamic>?;

        if (userData != null) {
          String? shopId = userData['ID'] as String?;
          if (shopId != null) {
            return shopId;
          } else {
            print('Shop ID is null.');
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
    return null;
  }

  Future<List<Map<String, dynamic>>> getTopProducts() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return [];
    }

    try {
      Map<String, Map<String, dynamic>> itemMap = {};

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Items')
          .where('ownerId', isEqualTo: userId)
          .get();

      for (var document in querySnapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        String itemName = data['itemName'];
        int quantity = data['quantity'];
        double total = data['total'];

        if (itemMap.containsKey(itemName)) {
          itemMap[itemName]!['quantity'] += quantity;
          itemMap[itemName]!['total'] += total;
        } else {
          itemMap[itemName] = {
            'itemName': itemName,
            'quantity': quantity,
            'total': total,
          };
        }
      }

      List<Map<String, dynamic>> topItems = itemMap.values.toList();

      topItems.sort((a, b) => b['quantity'].compareTo(a['quantity']));
      return topItems.take(3).toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool?> getShopStatus() async {
    String? userId = _auth.currentUser?.uid;

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('fnbLists')
          .where('Owner', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;
        bool open = docSnapshot['open'] ?? false;
        return open;
      } else {
        print('User document does not exist.');
      }
    } catch (error) {
      print('Error fetching shop status: $error');
    }
    return null;
  }

  Future<void> toggleShopStatus(bool status) async {
    String? userId = _auth.currentUser?.uid;

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('fnbLists')
          .where('Owner', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;
        String docId = docSnapshot.id;

        await _firestore.collection('fnbLists').doc(docId).update({
          'open': status,
        });
      } else {
        print('User document does not exist.');
      }
    } catch (error) {
      print('Error updating shop status: $error');
    }
  }

  Future<String> getHelperShopId() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('fnbLists')
          .where('Owner', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;
        Map<String, dynamic>? userData =
            docSnapshot.data() as Map<String, dynamic>?;

        if (userData != null) {
          String? shopId = userData['ID'] as String?;
          if (shopId != null) {
            return shopId;
          } else {
            print('Shop ID is null.');
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
    return 'null';
  }

  Future<bool?> getStockStatus(String itemId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Menu')
          .where('ID', isEqualTo: itemId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;
        bool open = docSnapshot['inStock'] ?? false;
        return open;
      } else {
        print('User document does not exist.');
      }
    } catch (error) {
      print('Error fetching shop status: $error');
    }
    return null;
  }

  Future<void> toggleStockStatus(bool status, String itemId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('Menu')
          .where('ID', isEqualTo: itemId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;
        String docId = docSnapshot.id;

        await _firestore.collection('Menu').doc(docId).update({
          'inStock': status,
        });
      } else {
        print('User document does not exist.');
      }
    } catch (error) {
      print('Error updating shop status: $error');
    }
  }

  Future<void> deleteStock(String itemId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('Menu')
          .where('ID', isEqualTo: itemId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;
        String docId = docSnapshot.id;

        await _firestore.collection('Menu').doc(docId).delete();
      } else {
        print('Menu document does not exist.');
      }
    } catch (error) {
      print('Error deleting stock: $error');
    }
  }

  Future<void> rateOrder(int cartId, double rating) async {
    try {
      final querySnapshot =
          await _cartListsRef.where('random-Id', isEqualTo: cartId).get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        await doc.reference.update({'Rated': rating});
      } else {
        print('No cart found with ID: $cartId');
      }
    } catch (error) {
      print('Error rating order: $error');
      throw error;
    }
  }

  Future<void> saveRating(String orderId, double rating) async {
    try {
      await _cartListsRef.doc(orderId).update({'Rated': rating});
    } catch (e) {
      print('Error saving rating: $e');
    }
  }

  Future<double?> getRate(int orderId) async {
    try {
      QuerySnapshot querySnapshot =
          await _cartListsRef.where('random-Id', isEqualTo: orderId).get();

      if (querySnapshot.docs.isNotEmpty) {
        var rateData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        double? rateValue = rateData['Rated'];
        if (rateValue != null) {
          return rateValue;
        }
      } else {
        print('No shop found with ID: $orderId');
      }
      print('not found');
      return null;
    } catch (error) {
      print('Error fetching shop data: $error');
      throw error;
    }
  }

  Future<bool> checkRate(int orderId) async {
    try {
      // Assuming _cartListsRef is a reference to the Firestore collection.
      QuerySnapshot querySnapshot =
          await _cartListsRef.where('orderId', isEqualTo: orderId).get();

      if (querySnapshot.docs.isNotEmpty) {
        var rateData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        bool? rated = rateData['Rated'];
        if (rated != null) {
          return true;
        }
      } else {
        print('No order found with ID: $orderId');
      }
      print('Rating not found');
      return false;
    } catch (error) {
      print('Error fetching order data: $error');
      throw error;
    }
  }

  Future<void> updateFnbRating(String shopId) async {
    try {
      // Get all cart items with the given shopId
      QuerySnapshot cartSnapshot =
          await _cartListsRef.where('shop_Id', isEqualTo: shopId).get();
      print('passed1');

      // Initialize variables to store rates and raters
      int rate1 = 0,
          rate2 = 0,
          rate3 = 0,
          rate4 = 0,
          rate5 = 0,
          totalRaters = 0;
      print('passed1.1');

      // Iterate through each cart item to calculate rates and total raters
      for (var doc in cartSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        print(data); // Print document data for debugging

        int rated = data['Rated'] ?? 0;
        print(rated);

        // Update rates based on rated value
        switch (rated) {
          case 1:
            rate1++;
            break;
          case 2:
            rate2++;
            break;
          case 3:
            rate3++;
            break;
          case 4:
            rate4++;
            break;
          case 5:
            rate5++;
            break;
          default:
            break;
        }
      }
      print(totalRaters);

      // Calculate total raters
      totalRaters = rate1 + rate2 + rate3 + rate4 + rate5;
      // Calculate average rating
      double rating = totalRaters != 0
          ? (rate1 + rate2 * 2 + rate3 * 3 + rate4 * 4 + rate5 * 5) /
              totalRaters
          : 0;

      // Update FnbList with calculated rates and rating
      QuerySnapshot fnbListSnapshot =
          await _fnbListsRef.where('ID', isEqualTo: shopId).get();
      if (fnbListSnapshot.docs.isNotEmpty) {
        String fnbDocId = fnbListSnapshot.docs.first.id;

        // Update FnbList with calculated rates and rating
        await _fnbListsRef.doc(fnbDocId).update({
          'Rate_1': rate1,
          'Rate_2': rate2,
          'Rate_3': rate3,
          'Rate_4': rate4,
          'Rate_5': rate5,
          'Raters': totalRaters,
          'Rating': rating,
        });
        print('passed4');
      } else {
        print('Error: No FnbList document found with shopId: $shopId');
      }
    } catch (error) {
      print('Error updating FnbList: $error');
      throw error;
    }
  }
}
