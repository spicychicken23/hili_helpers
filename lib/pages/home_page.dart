import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hili_helpers/components/home.dart';
import 'package:hili_helpers/components/auth.dart';
import 'package:hili_helpers/navigation.dart';
import 'package:hili_helpers/models/promo.dart';
import 'package:hili_helpers/pages/services_page.dart';
import 'package:hili_helpers/services/database_service.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});
  static String id = 'HomePage';

  final User? user = Auth().currentUser;

  Future<void> singOut() async {
    await Auth().signOut();
  }

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  late Stream<List<Promo>> promosStream;
  late String? userName = 'User';
  late String? userStatus = 'User';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    promosStream = DatabaseService().getPromo();
  }

  Future<void> _fetchUserData() async {
    userName = await DatabaseService().getUsersName();
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
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Welcome, $userName.',
                  style: const TextStyle(
                    color: Color(0xFFD3A877),
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'DM Sans',
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: IconButton(
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: CustomSearchBar(),
                    );
                  },
                  icon: Container(
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
                        top: Radius.circular(15),
                        bottom: Radius.circular(15),
                      ),
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Get assistance now!',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.search,
                          color: Color(0xFFFFFFFF),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
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
                                                  context, FnbPage.id,
                                                  arguments: 'FNB');
                                            }),
                                            allBtn(Icons.school, 'EDU', () {
                                              Navigator.pushNamed(
                                                  context, FnbPage.id,
                                                  arguments: 'EDU');
                                            }),
                                            allBtn(Icons.build, 'DOM', () {
                                              Navigator.pushNamed(
                                                  context, FnbPage.id,
                                                  arguments: 'DOM');
                                            }),
                                            allBtn(Icons.drive_eta, 'VEH', () {
                                              Navigator.pushNamed(
                                                  context, FnbPage.id,
                                                  arguments: 'VEH');
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
                          accBtn(
                              'lib/images/FNB.png', context, FnbPage.id, 'FNB'),
                          accBtn(
                              'lib/images/EDU.png', context, FnbPage.id, 'EDU'),
                          accBtn(
                              'lib/images/DOM.png', context, FnbPage.id, 'DOM'),
                          accBtn(
                              'lib/images/VEH.png', context, FnbPage.id, 'VEH'),
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
                      height: 240,
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
                              itemBuilder: (context, index) => NewsPromo(
                                promo: promos[index],
                              ),
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
      bottomNavigationBar: CustomNavigationBar(
        userStatus: userStatus,
        currentIndex: _currentIndex,
        onPageChanged: _onPageChanged,
      ),
    );
  }
}
