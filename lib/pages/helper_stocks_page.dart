import 'package:flutter/material.dart';
import 'package:hili_helpers/components/helper.dart';
import 'package:hili_helpers/models/menu.dart';
import 'package:hili_helpers/services/database_service.dart';
import 'helper_addmenu.dart';

class HelperStocksPage extends StatefulWidget {
  HelperStocksPage({super.key});

  @override
  _HelperStocksPageState createState() => _HelperStocksPageState();
}

class _HelperStocksPageState extends State<HelperStocksPage> {
  late Stream<List<Menu>> stocksListsStream;
  late Future<String> shopIdFuture;

  @override
  void initState() {
    super.initState();
    shopIdFuture = _loadShopId();
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
                    Row(
                      children: <Widget>[
                        const Text(
                          'Stocks',
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'DM Sans',
                          ),
                        ),
                        const Spacer(),
                        FutureBuilder<String>(
                          future: shopIdFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData) {
                              String shopId = snapshot.data!;
                              return IconButton(
                                icon: const Icon(Icons.add_box_rounded),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddMenuItemPage(shopId: shopId),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return const Text('Unable to load data');
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                      child: Divider(),
                    ),
                    Container(
                      height: 620,
                      child: FutureBuilder<String>(
                        future: shopIdFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            String shopId = snapshot.data!;
                            return StreamBuilder<List<Menu>>(
                              stream: stocksListsStream,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (snapshot.hasData) {
                                  List<Menu> stocksLists = snapshot.data!;
                                  return ListView.builder(
                                    itemCount: stocksLists.length,
                                    itemBuilder: (context, index) =>
                                        StocksListing(
                                      menu: stocksLists[index],
                                      shopId: shopId,
                                    ),
                                  );
                                } else {
                                  return const Text('No data available');
                                }
                              },
                            );
                          } else {
                            return const Text('Unable to load data');
                          }
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
