import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hili_helpers/models/cart.dart';
import 'package:hili_helpers/models/promo.dart';
import 'package:hili_helpers/models/search.dart';
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

  Future<fnb?> fetchFnbByShopId(String shopId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('fnbLists')
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

  List<Shop> fetchSpecificSearchTerms(String type) {
    List<Shop> shops = [];
    FirebaseFirestore.instance
        .collection('fnbLists')
        .where('ID', isGreaterThanOrEqualTo: type)
        .where('ID', isLessThan: type + '\uf8ff')
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        String name = doc.data()['Name'];
        String id = doc.data()['ID'];
        shops.add(Shop(name: name, id: id));
      }
    }).catchError((error) {
      print("Error fetching search terms from Firestore: $error");
    });
    return shops;
  }

  List<Shop> fetchSearchTerms() {
    List<Shop> shops = [];
    FirebaseFirestore.instance
        .collection('fnbLists')
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        String name = doc.data()['Name'];
        String id = doc.data()['ID'];
        shops.add(Shop(name: name, id: id));
      }
    }).catchError((error) {
      print("Error fetching search terms from Firestore: $error");
    });
    return shops;
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

  Future<Map<String, dynamic>?> fetchMenuItemDataByShopId(String shopId) async {
    try {
      // Query the 'Menu' collection for documents where 'shop_id' field matches the provided shopId
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Menu')
          .where('ID', isEqualTo: shopId)
          .get();

      // Check if any documents are found
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        //print (doc.data() as Map<String, dynamic>?);
        return doc.data() as Map<String, dynamic>?;
      } else {
        print('No document found with shop_id: $shopId');
        return null;
      }
    } catch (e) {
      print('Error fetching document: $e');
      return null;
    }
  }

  Future<void> updateMenuItem(
      String shopId, Map<String, dynamic> updatedData) async {
    try {
      // Query the 'Menu' collection to find the document with the matching 'Shop_ID'
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Menu')
          .where('ID', isEqualTo: shopId)
          .get();

      // Check if any documents are found
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document's ID
        DocumentSnapshot doc = querySnapshot.docs.first;
        String docId = doc.id;

        // Update the document with the new data
        await FirebaseFirestore.instance
            .collection('Menu')
            .doc(docId)
            .update(updatedData);
      } else {
        print('No document found with Shop_ID: $shopId');
      }
    } catch (e) {
      print('Error updating document: $e');
    }
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
        final String shopID = doc['shop_Id'];

        final fnblistQuerySnapshot =
            await _fnbListsRef.where('ID', isEqualTo: shopID).get();

        if (fnblistQuerySnapshot.docs.isNotEmpty) {
          final fnblistDoc = fnblistQuerySnapshot.docs.first;

          final updates = {
            'Raters': FieldValue.increment(1),
          };

          if (rating == 1) {
            updates['Rate_1'] = FieldValue.increment(1);
          } else if (rating == 2) {
            updates['Rate_2'] = FieldValue.increment(1);
          } else if (rating == 3) {
            updates['Rate_3'] = FieldValue.increment(1);
          } else if (rating == 4) {
            updates['Rate_4'] = FieldValue.increment(1);
          } else if (rating == 5) {
            updates['Rate_5'] = FieldValue.increment(1);
          }

          await fnblistDoc.reference.update(updates);

          // Fetch the updated document to get the latest counts
          final updatedFnblistDoc = await fnblistDoc.reference.get();

          final rate1 = updatedFnblistDoc['Rate_1'] ?? 0;
          final rate2 = updatedFnblistDoc['Rate_2'] ?? 0;
          final rate3 = updatedFnblistDoc['Rate_3'] ?? 0;
          final rate4 = updatedFnblistDoc['Rate_4'] ?? 0;
          final rate5 = updatedFnblistDoc['Rate_5'] ?? 0;
          final raters = updatedFnblistDoc['Raters'] ?? 0;

          if (raters > 0) {
            final totalRating =
                (rate1 * 1 + rate2 * 2 + rate3 * 3 + rate4 * 4 + rate5 * 5) /
                    raters;
            await fnblistDoc.reference.update({'Rating': totalRating});
          }
        } else {
          print('No corresponding document found in fnblists with ID: $shopID');
        }
      } else {
        print('No cart found with ID: $cartId');
      }
    } catch (error) {
      print('Error rating order: $error');
      throw error;
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

  Future<String?> getUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.email;
  }

  Future<List<Map<String, dynamic>>> fetchItemsByRandomId(int id) async {
    String randomId = id.toString();
    List<Map<String, dynamic>> items = [];
    print(id);
    try {
      Query<Map<String, dynamic>> itemsCollection =
          FirebaseFirestore.instance.collection('Items');

      QuerySnapshot querySnapshot = await itemsCollection.get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        String docId = doc.id;
        List<String> idParts = docId.split('_');
        if (idParts.length > 1 && idParts[1] == randomId) {
          String itemName = doc['itemName'];
          int quantity = doc['quantity'];
          items.add({'itemName': itemName, 'quantity': quantity});
        }
      }

      if (items.isEmpty) {
        print('No items found for the given randomId');
      }
    } catch (e) {
      print('Error fetching items: $e');
    }

    return items;
  }

  Future<List<Map<String, dynamic>>> fetchCustomersById(String id) async {
    List<Map<String, dynamic>> customerInfo = [];
    try {
      CollectionReference itemsCollection =
          FirebaseFirestore.instance.collection('users');

      QuerySnapshot querySnapshot = await itemsCollection
          .where(FieldPath.documentId, isEqualTo: id)
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        String address = doc['address'];
        String phoneNumber = doc['phoneNumber'];
        String name = doc['name'];

        customerInfo.add(
            {'address': address, 'phoneNumber': phoneNumber, 'name': name});
      }

      if (customerInfo.isEmpty) {
        throw Exception('No items found for the given customerId');
      }
    } catch (e) {
      print('Error fetching items: $e');
    }

    return customerInfo;
  }

  Stream<List<cart>> getOrders() {
    String? userId = _auth.currentUser?.uid;

    return _firestore
        .collection('fnbLists')
        .where('Owner', isEqualTo: userId)
        .snapshots()
        .asyncMap((querySnapshot) async {
      if (querySnapshot.docs.isEmpty) {
        return [];
      }
      String shopId = querySnapshot.docs.first['ID'];

      QuerySnapshot ordersSnapshot = await _cartListsRef
          .where('shop_Id', isEqualTo: shopId)
          .where('status', isEqualTo: 'On Going')
          .get();

      return ordersSnapshot.docs.map((doc) {
        return cart.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> updateStatus(String id) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('CartList')
        .where('cart_Id', isEqualTo: id)
        .get();

    DocumentSnapshot document = querySnapshot.docs.first;
    await FirebaseFirestore.instance
        .collection('CartList')
        .doc(document.id)
        .update({'status': 'Completed'});
  }

  Future<void> updateShopName(String shopId, String newName) async {
    try {
      QuerySnapshot querySnapshot =
          await _fnbListsRef.where('ID', isEqualTo: shopId).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;
        String docId = docSnapshot.id;

        await _fnbListsRef.doc(docId).update({
          'Name': newName,
        });
      } else {
        print('No shop found with ID: $shopId');
      }
    } catch (error) {
      print('Error updating shop name: $error');
      throw error;
    }
  }

  Future<void> deleteShop(String shopId) async {
    try {
      // Step 1: Delete shop details from fnbLists collection
      await _firestore.collection('fnbLists').doc(shopId).delete();

      // Step 2: Delete menu items associated with the shop from Menu collection
      QuerySnapshot menuItemsSnapshot = await _firestore
          .collection('Menu')
          .where('ID', isEqualTo: shopId)
          .get();

      // Step 3: Delete each menu item document
      if (menuItemsSnapshot.docs.isNotEmpty) {
        WriteBatch batch = _firestore.batch();
        menuItemsSnapshot.docs.forEach((doc) {
          batch.delete(doc.reference);
        });
        await batch.commit();
      }

      print('Shop and associated menu items deleted successfully.');
    } catch (error) {
      print('Error deleting shop: $error');
      throw error;
    }
  }
}
