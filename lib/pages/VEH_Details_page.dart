import 'package:flutter/material.dart';
import 'package:hili_helpers/components/fnb.dart';

class VehDetailsPage extends StatefulWidget {
  /*
  final fnb Fnb;
  EduDetailsPage({Key? key, required this.Fnb}) : super(key: key);
  */

  @override
  _VehDetailsPageState createState() => _VehDetailsPageState();
}

class _VehDetailsPageState extends State<VehDetailsPage> {
  /*
  late Stream<List<Menu>> menuListsStream;
  late int _randomId;
  int _totalQuantity = 0;
  

  @override
  void initState() {
    super.initState();
    _randomId = Random().nextInt(1000000000);
    menuListsStream = DatabaseService().getMenuLists();
  }

  void updateTotalQuantity(int newQuantity, bool status) {
    setState(() {
      status ? _totalQuantity += newQuantity : _totalQuantity -= newQuantity;
    });
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFE4E6ED),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    color: const Color(0xFFff914d),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    height: 250,
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
                        Text(
                          'Ali Tayar',
                          style: const TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'DM Sans',
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 350,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Tire Types',
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    /*
                      Container(
                        height: 300,
                        child: StreamBuilder<List<Menu>>(
                          stream: menuListsStream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting ||
                                snapshot.data == null) {
                              return const CircularProgressIndicator();
                            } else {
                              List<Menu> menuLists = snapshot.data!;
                              return ListView.builder(
                                itemCount: menuLists.length,
                                itemBuilder: (context, index) => menuListing(
                                  menu: menuLists[index],
                                  shopId: widget.Fnb.ID,
                                  randomId: _randomId,
                                  updateTotalQuantity: updateTotalQuantity,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      */
                  ],
                ),
              ),
            ),
            Positioned(
              top: 180,
              left: 20,
              right: 20,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color(0xFF5983B1),
                      Color(0xFF2367B1),
                    ],
                  ),
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20), bottom: Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            '3.8',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 50,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '1 Raters',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'DM Sans',
                            ),
                          ),
                        ],
                      ),
                      const VerticalDivider(
                        thickness: 3,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          ratingBar('5', 0),
                          ratingBar('4', 0),
                          ratingBar('3', 1),
                          ratingBar('2', 0),
                          ratingBar('1', 0),
                        ],
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Column(
                        children: [
                          ClipOval(
                            child: Image.network(
                              'https://drive.usercontent.google.com/download?id=1pE1R5WqUnL5Cfn5cVBhK8ppQD20LUGht',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: Color(0xFFD3A877),
                            //size: 25,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      /*
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _totalQuantity > 0
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfirmOrder(
                      shop_Id: widget.Fnb.ID,
                      random_Id: _randomId,
                    ),
                  ),
                );
                print(_totalQuantity);
              },
              backgroundColor: const Color(0xFFCCA67B),
              foregroundColor: const Color(0xFF000000),
              label: const Text("Proceed"),
            )
          : null,
          */
    );
  }
}
