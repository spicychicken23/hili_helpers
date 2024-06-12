import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:hili_helpers/components/home.dart';
import 'package:hili_helpers/components/services.dart';
import 'package:hili_helpers/models/servicesLists.dart';
import 'package:hili_helpers/services/database_service.dart';

class FnbPage extends StatefulWidget {
  FnbPage({Key? key}) : super(key: key);
  static String id = 'FNB_page';

  @override
  _FnbPageState createState() => _FnbPageState();
}

class _FnbPageState extends State<FnbPage> {
  late Stream<List<fnb>> fnbListsStream;
  late String? pageType;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is String) {
      pageType = args;
      fnbListsStream = DatabaseService().getFnbLists(pageType!);
    } else {
      pageType = 'default';
      fnbListsStream = DatabaseService().getFnbLists(pageType!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageInfo = getPageInfo(pageType!);

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
                color: pageInfo.color,
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
                    Text(
                      pageInfo.title,
                      style: const TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                    Text(
                      pageInfo.disclaimer,
                      style: const TextStyle(
                        color: Color.fromARGB(172, 255, 255, 255),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                    const SizedBox(height: 20),
                    DecoratedBox(
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
                          top: Radius.circular(20),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 20, 120, 0),
                        child: const Text(
                          'Start supporting your local businesses now!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF5983B1),
                          Color(0xFF2367B1),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate: SpecificSearchBar(shopType: pageType!),
                        );
                      },
                      icon: const DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(244, 243, 243, 1),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                            bottom: Radius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Get assistance now!',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'DM Sans',
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.search,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Available Businesses',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 350,
                      child: StreamBuilder<List<fnb>>(
                        stream: fnbListsStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting ||
                              snapshot.data == null) {
                            return const CircularProgressIndicator();
                          } else {
                            List<fnb> fnbLists = snapshot.data!;
                            return ListView.builder(
                              itemCount: fnbLists.length,
                              itemBuilder: (context, index) =>
                                  servicesListing(fnbs: fnbLists[index]),
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
    );
  }
}
