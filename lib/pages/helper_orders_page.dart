import 'package:flutter/material.dart';
import 'package:hili_helpers/components/helper.dart';
import 'package:hili_helpers/models/cart.dart';
import 'package:hili_helpers/models/menu.dart';
import 'package:hili_helpers/services/database_service.dart';

class HelperOrdersPage extends StatefulWidget {
  HelperOrdersPage({super.key});

  @override
  _HelperOrdersPageState createState() => _HelperOrdersPageState();
}

class _HelperOrdersPageState extends State<HelperOrdersPage> {
  late Stream<List<Menu>> stocksListsStream;
  late Future<String> shopIdFuture;
  late Stream<List<cart>> OnGoingOrders;
  double? globalRated;

  @override
  void initState() {
    super.initState();
    shopIdFuture = _loadShopId();
    OnGoingOrders = DatabaseService().getOrders();
  }

  Future<String> _loadShopId() async {
    String shopId = await DatabaseService().getHelperShopId();
    stocksListsStream = DatabaseService().getMenuLists();
    return shopId;
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
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.chevron_left),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Orders',
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                      child: Divider(),
                    ),
                    Container(
                      height: 350,
                      child: StreamBuilder<List<cart>>(
                        stream: OnGoingOrders,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final order = snapshot.data![index];
                              return ordersActive(
                                databaseService: DatabaseService(),
                                order: order,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
