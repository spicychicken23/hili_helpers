import 'package:flutter/material.dart';
import 'package:hili_helpers/components/activity.dart';
import 'package:hili_helpers/models/cart.dart';
import 'package:hili_helpers/navigation.dart';
import 'package:hili_helpers/pages/home_page.dart';
import 'package:hili_helpers/services/database_service.dart';
import 'package:intl/intl.dart';

class ActPage extends StatefulWidget {
  ActPage({super.key});
  static String id = 'ACT_page';

  @override
  _ActPageState createState() => _ActPageState();
}

class _ActPageState extends State<ActPage> {
  int _currentIndex = 1;

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  late Stream<List<cart>> completedStream;
  late Stream<List<cart>> onGoingStream;
  late String? userStatus = 'User';

  @override
  void initState() {
    super.initState();
    completedStream = DatabaseService().getCartCom();
    onGoingStream = DatabaseService().getCartAct();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    userStatus = await DatabaseService().getStatus();
    setState(() {});
  }

  // void _showOrderDetails(BuildContext context, cart order) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text('Order Details'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text('Cart ID: ${order.randomId}'),
  //             Text('Order Date: ${order.order_date.toDate()}'),
  //             Text('Quantity: ${order.quantity}'),
  //             Text('Total: ${order.subtotal}'),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: Text('Close'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  void _showOrderDetails(BuildContext context, cart order) {
    showDialog(
      context: context,
      builder: (context) {
        // Format the total with 2 decimal places
        String formattedTotal = order.subtotal.toStringAsFixed(2);
        // Format the order date to display only minutes
        String formattedOrderDate =
            DateFormat('yyyy-MM-dd HH:mm').format(order.order_date.toDate());
        //Future<String?> shopName = DatabaseService().getShopName(order.shop_Id);

        return AlertDialog(
          title: const Text(
            'Order Details',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          content: FutureBuilder<String?>(
            future: DatabaseService().getShopName(order.shop_Id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                String? shopName = snapshot.data ?? 'Unknown';
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(
                      color: Colors.grey, // Set the color of the divider
                      thickness: 2, // Set the thickness of the divider
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        //'FNB ID: ${order.shop_Id}',
                        '${shopName}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Cart ID: ${order.randomId}',
                      //style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Order Date: $formattedOrderDate',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Quantity: ${order.quantity}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total : RM$formattedTotal',
                      style: const TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Close',
                style: TextStyle(
                  color: Color.fromARGB(255, 228, 159, 82),
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFE4E6ED),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _currentIndex = 0;
                            });
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.chevron_left),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Activity',
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 100,
                      child: StreamBuilder<List<cart>>(
                        stream: onGoingStream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          //not functioning well
                          // return ListView(
                          //   scrollDirection: Axis.horizontal,
                          //   shrinkWrap: true,
                          //   children: snapshot.data!.map((order) {
                          //     return Padding(
                          //       padding:
                          //           const EdgeInsets.symmetric(horizontal: 5),
                          //       child: GestureDetector(
                          //         onTap: () {
                          //           _showOrderDetails(context, order);
                          //         },
                          //         child: actOnGoing(
                          //           databaseService: DatabaseService(),
                          //           order: order,
                          //         ),
                          //       ),
                          //     );
                          //   }).toList(),
                          // );

                          // new version
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final order = snapshot.data![index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: GestureDetector(
                                  onTap: () {
                                    _showOrderDetails(context, order);
                                  },
                                  child: actOnGoing(
                                    databaseService: DatabaseService(),
                                    order: order,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    const Divider(
                      color: Colors.black,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'History',
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 350,
                      child: StreamBuilder<List<cart>>(
                        stream: completedStream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return actHistory(
                                databaseService: DatabaseService(),
                                order: snapshot.data![index],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        userStatus: userStatus,
        currentIndex: _currentIndex,
        onPageChanged: _onPageChanged,
      ),
    );
  }
}
