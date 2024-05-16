import 'package:flutter/material.dart';
import 'package:hili_helpers/components/activity.dart';
import 'package:hili_helpers/models/cart.dart';
import 'package:hili_helpers/navigation.dart';
import 'package:hili_helpers/pages/home_page.dart';
import 'package:hili_helpers/services/database_service.dart';

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
                            //change
                            Navigator.popUntil(
                                context, ModalRoute.withName(HomePage.id));
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
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            children: snapshot.data!.map((order) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: actOnGoing(
                                  databaseService: DatabaseService(),
                                  order: order,
                                ),
                              );
                            }).toList(),
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
