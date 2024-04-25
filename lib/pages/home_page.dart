import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hili_helpers/components/buttons.dart';
import 'package:hili_helpers/components/auth.dart';
import 'package:hili_helpers/navigation.dart';
import 'package:hili_helpers/models/promo.dart';
import 'package:hili_helpers/pages/FNB_page.dart';
import 'package:hili_helpers/services/database_service.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  final User? user = Auth().currentUser;

  Future<void> singOut() async {
    await Auth().signOut();
  }

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Stream<List<Promo>> promosStream;
  late String? userName = 'User';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    promosStream = DatabaseService().getPromo();
  }

  Future<void> _fetchUserData() async {
    userName = await DatabaseService().getUsersName();
    setState(() {}); // Update the UI after fetching user data
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
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Welcome, $userName.',
                  style: const TextStyle(
                    color: Color(0xFFD3A877),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'DM Sans',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF5983B1),
                        Color(0xFF2367B1),
                      ],
                    ),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                      bottom: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Get assistance now!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(244, 243, 243, 1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: <Widget>[
                            const Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15),
                                  border: InputBorder.none,
                                  hintText: "What's on your mind?",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0C171D),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(
                                        15,
                                      )),
                                ),
                                child: const Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Services',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'DM Sans',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 350,
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            allBtn(Icons.restaurant, 'FNB', () {
                                              Navigator.pushNamed(
                                                  context, FnbPage.id);
                                            }),
                                            allBtn(Icons.school, 'EDU', () {
                                              print('EDU button pressed');
                                            }),
                                            allBtn(Icons.build, 'DOM', () {
                                              print('DOM button pressed');
                                            }),
                                            allBtn(Icons.drive_eta, 'VEH', () {
                                              print('VEH button pressed');
                                            }),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                'See All',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'DM Sans',
                                ),
                              ),
                              Icon(Icons.chevron_right),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      height: 150,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          accBtn('lib/images/FNB.png', context, FnbPage.id),
                          accBtn('lib/images/EDU.png', context, FnbPage.id),
                          accBtn('lib/images/DOM.png', context, FnbPage.id),
                          accBtn('lib/images/VEH.png', context, FnbPage.id),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Stay Up To Date!',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      height: 160,
                      child: StreamBuilder<List<Promo>>(
                        stream: promosStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting ||
                              snapshot.data == null) {
                            return const CircularProgressIndicator();
                          } else {
                            List<Promo> promos = snapshot.data!;
                            return ListView.builder(
                              itemCount: promos.length,
                              itemBuilder: (context, index) =>
                                  NewsPromo(promo: promos[index]),
                            );
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
      bottomNavigationBar: const NavBar(),
    );
  }
}
