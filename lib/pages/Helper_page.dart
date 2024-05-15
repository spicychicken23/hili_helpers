import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hili_helpers/components/helper.dart';
import 'package:hili_helpers/navigation.dart';
import 'package:hili_helpers/pages/home_page.dart';

class HelperPage extends StatefulWidget {
  HelperPage({super.key});
  static String id = 'Helper_page';

  @override
  _HelperPageState createState() => _HelperPageState();
}

class _HelperPageState extends State<HelperPage> {
  int _currentIndex = 4;
  DateTime selectedDate = DateTime.now();
  late String? userStatus = 'Helper';

  String _dropdownValue = 'All';
  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _dropdownCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _dropdownValue = selectedValue;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
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
                            Navigator.popUntil(
                                context, ModalRoute.withName(HomePage.id));
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
                      SwitchExample()
                    ])
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const HelperNaviBar(),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: <Widget>[
                    const Text(
                      'Overview',
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 20,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xfff7f2f9),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          bottomLeft: Radius.circular(50),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButton<String>(
                        items: const [
                          DropdownMenuItem(
                            value: 'Day',
                            child: Text('Day', style: TextStyle(fontSize: 14)),
                          ),
                          DropdownMenuItem(
                            value: 'Week',
                            child: Text('Week', style: TextStyle(fontSize: 14)),
                          ),
                          DropdownMenuItem(
                            value: 'Month',
                            child:
                                Text('Month', style: TextStyle(fontSize: 14)),
                          ),
                          DropdownMenuItem(
                            value: 'Year',
                            child: Text('Year', style: TextStyle(fontSize: 14)),
                          ),
                          DropdownMenuItem(
                            value: 'All',
                            child: Text('All', style: TextStyle(fontSize: 14)),
                          ),
                        ],
                        value: _dropdownValue,
                        onChanged: _dropdownCallback,
                        underline: Container(),
                        dropdownColor: Colors.white,
                      ),
                    ),
                    Container(
                      width: 80,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(50.0),
                                bottomRight: Radius.circular(50.0)),
                          ),
                        ),
                        onPressed: _dropdownValue == 'All'
                            ? null
                            : () => _selectDate(context),
                        child: const Text(
                          'Date',
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 200,
                child: LineChart(
                  LineChartData(
                    minY: 1,
                    maxY: 10,
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 3),
                          FlSpot(2.6, 2),
                          FlSpot(4.9, 5),
                          FlSpot(6.8, 3.1),
                          FlSpot(8, 4),
                          FlSpot(9.5, 3),
                          FlSpot(11, 4),
                        ],
                        color: const Color(0xFF2367B1),
                        barWidth: 5,
                        isCurved: true,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(
                          show: false,
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                        ),
                      )
                    ],
                    titlesData: const FlTitlesData(
                      show: false,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    statsCard(
                        icon: Icons.money_off_rounded,
                        title: 'Sales',
                        value: '200'),
                    statsCard(
                        icon: Icons.check_box_outlined,
                        title: 'Items',
                        value: '200'),
                    statsCard(
                        icon: Icons.history_toggle_off_rounded,
                        title: 'Transactions',
                        value: '200'),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Top Products',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 20,
                    fontFamily: 'DM Sans',
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: const [
                    popularItems(),
                    popularItems(),
                    popularItems(),
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
