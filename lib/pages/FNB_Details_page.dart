import 'package:flutter/material.dart';
import 'package:hili_helpers/components/buttons.dart';
import 'package:hili_helpers/models/fnbLists.dart';
import 'package:hili_helpers/components/displays.dart';
import 'package:hili_helpers/services/database_service.dart';
import '../models/menu.dart';

class NextPage extends StatefulWidget {
  final fnb Fnb;
  NextPage({Key? key, required this.Fnb}) : super(key: key);

  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  late Stream<List<Menu>> menuListsStream;

  @override
  void initState() {
    super.initState();
    menuListsStream = DatabaseService().getMenuLists() as Stream<List<Menu>>;
  }

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
                    color: const Color(0xFFDB9439),
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
                          widget.Fnb.Name,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Menu',
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
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
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  )),
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
                            widget.Fnb.Rating.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 50,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${widget.Fnb.Raters} Raters',
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
                          buildProgressBar(
                              '5', widget.Fnb.Rate_5 / widget.Fnb.Raters),
                          buildProgressBar(
                              '4', widget.Fnb.Rate_4 / widget.Fnb.Raters),
                          buildProgressBar(
                              '3', widget.Fnb.Rate_3 / widget.Fnb.Raters),
                          buildProgressBar(
                              '2', widget.Fnb.Rate_2 / widget.Fnb.Raters),
                          buildProgressBar(
                              '1', widget.Fnb.Rate_1 / widget.Fnb.Raters),
                        ],
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Column(
                        children: [
                          ClipOval(
                            child: Image.network(
                              widget.Fnb.Icon,
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
    );
  }
}
