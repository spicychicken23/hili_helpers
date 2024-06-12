import 'package:flutter/material.dart';
import 'package:hili_helpers/components/helper.dart';
import 'package:hili_helpers/models/servicesLists.dart';
import 'package:hili_helpers/navigation.dart';
import 'package:hili_helpers/services/database_service.dart';

class HelperPage extends StatefulWidget {
  HelperPage({super.key});
  static String id = 'Helper_page';

  @override
  _HelperPageState createState() => _HelperPageState();
}

class _HelperPageState extends State<HelperPage> {
  int _currentIndex = 3;
  late String? userStatus = 'Helper';
  late double? salesData = 0;
  late int? quantitySold = 0;
  late int? transactionsMade = 0;
  late fnb shop;

  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _fetchUserData() async {
    salesData = await DatabaseService().totalSales();
    quantitySold = await DatabaseService().totalQuantity();
    transactionsMade = await DatabaseService().totalTransaction();

    setState(() {
      salesData = salesData;
      quantitySold = quantitySold;
      transactionsMade = transactionsMade;
    });
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
                    const Row(children: <Widget>[
                      Text(
                        'Helper Dashboard',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'DM Sans',
                        ),
                      ),
                      Spacer(),
                      shopStatus()
                    ])
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const HelperNaviBar(),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        statsCard(
                            icon: Icons.money_off_rounded,
                            title: 'Sales',
                            value: salesData?.toStringAsFixed(2) ?? '0.00'),
                        statsCard(
                            icon: Icons.check_box_outlined,
                            title: 'Items sold',
                            value: quantitySold.toString()),
                        statsCard(
                            icon: Icons.check_box_outlined,
                            title: 'Transaction',
                            value: transactionsMade.toString()),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        color: Color(0xff38220f),
                      ),
                      child: const ShopRatings(),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Popular Items",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    PopularItems(sales: salesData, quantities: quantitySold),
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
