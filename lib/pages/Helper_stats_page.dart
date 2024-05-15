import 'package:flutter/material.dart';
import 'package:hili_helpers/components/helper.dart';
import 'package:hili_helpers/navigation.dart';

class HelperStatsPage extends StatefulWidget {
  HelperStatsPage({super.key});

  @override
  _HelperStatsPageState createState() => _HelperStatsPageState();
}

class _HelperStatsPageState extends State<HelperStatsPage> {
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
                    ])
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
    );
  }
}
