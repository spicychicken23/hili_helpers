import 'package:flutter/material.dart';
import 'package:hili_helpers/components/helper.dart';
import 'package:hili_helpers/navigation.dart';
import 'package:hili_helpers/services/database_service.dart';

class HelperPage extends StatefulWidget {
  const HelperPage({super.key});
  static String id = 'Helper_page';

  @override
  // ignore: library_private_types_in_public_api
  _HelperPageState createState() => _HelperPageState();
}

class _HelperPageState extends State<HelperPage> {
  int _currentIndex = 3;
  String? userStatus = 'Helper';
  double? salesData = 0;
  int? quantitySold = 0;
  int? transactionsMade = 0;
  final TextEditingController _shopNameController = TextEditingController();

  @override
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

  void _editShopName() async {
    String? shopId = await DatabaseService().getHelperShopId();
    String? currentShopName = await DatabaseService().getShopName(shopId);
    _shopNameController.text = currentShopName ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return EditShopNameDialog(
          shopNameController: _shopNameController,
          onUpdateShopName: (newShopName) async {
            String? shopId = await DatabaseService().getHelperShopId();
            await DatabaseService().updateShopName(shopId, newShopName);
          },
          onCloseDialog: () {
            Navigator.pop(context); // Close the dialog
          },
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
                          'Dashboard',
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'DM Sans',
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            size: 20,
                          ),
                          onPressed: _editShopName,
                        ),
                        const shopStatus()
                      ],
                    ),
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

class EditShopNameDialog extends StatefulWidget {
  final TextEditingController shopNameController;
  final Function(String) onUpdateShopName;
  final VoidCallback onCloseDialog; // Add this callback

  const EditShopNameDialog({
    super.key,
    required this.shopNameController,
    required this.onUpdateShopName,
    required this.onCloseDialog, // Add this parameter
  });

  @override
  _EditShopNameDialogState createState() => _EditShopNameDialogState();
}

class _EditShopNameDialogState extends State<EditShopNameDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Shop Name'),
      content: TextField(
        controller: widget.shopNameController,
        decoration: const InputDecoration(hintText: 'Enter new shop name'),
      ),
      actions: [
        TextButton(
          onPressed: widget.onCloseDialog, // Use the callback here
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            widget.onUpdateShopName(widget.shopNameController.text);
            widget.onCloseDialog(); // Use the callback here
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
