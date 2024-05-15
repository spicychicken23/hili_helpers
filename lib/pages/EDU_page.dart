import 'package:flutter/material.dart';
import 'package:hili_helpers/components/edu.dart';

class EduPage extends StatefulWidget {
  EduPage({super.key});
  static String id = 'EDU_page';

  @override
  _EduPageState createState() => _EduPageState();
}

class _EduPageState extends State<EduPage> {
  /*
  late Stream<List<fnb>> fnbListsStream;

  @override
  void initState() {
    super.initState();
    fnbListsStream = DatabaseService().getFnbLists();
  }
  */

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
                color: const Color(0xFF38b6ff),
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
                      'Education',
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 25,
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
                          //bottom: Radius.circular(20),
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
              Padding(
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
                  child: Center(
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(244, 243, 243, 1),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                          bottom: Radius.circular(20),
                        ),
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
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
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
                    SizedBox(height: 10),
                    SizedBox(
                      height: 350,
                      child: eduListing(),
                    )
                    /*
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
                                  fnbListing(fnbs: fnbLists[index]),
                            );
                          }
                        },
                      ),
                    ),
                    */
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
