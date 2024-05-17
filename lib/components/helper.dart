import 'package:flutter/material.dart';
import 'package:hili_helpers/components/services.dart';
import 'package:hili_helpers/models/servicesLists.dart';
import 'package:hili_helpers/pages/helper_stats_page.dart';
import 'package:hili_helpers/services/database_service.dart';

class Selected extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final String isEnd;
  final VoidCallback onTap;

  const Selected({
    Key? key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isEnd,
  }) : super(key: key);

  @override
  _SelectedState createState() => _SelectedState();
}

class _SelectedState extends State<Selected> {
  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius;
    if (widget.isEnd == 'Right') {
      borderRadius = const BorderRadius.only(
        topRight: Radius.circular(10),
        bottomRight: Radius.circular(10),
      );
    } else if (widget.isEnd == 'Left') {
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(10),
        bottomLeft: Radius.circular(10),
      );
    } else {
      borderRadius = BorderRadius.circular(0);
    }

    return Expanded(
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.all(5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.isSelected
                ? const Color(0xff38220f)
                : const Color(0xFFdbc1ac),
            borderRadius: borderRadius,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                widget.icon,
                color:
                    widget.isSelected ? Colors.white : const Color(0xff38220f),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  color: widget.isSelected
                      ? Colors.white
                      : const Color(0xff38220f),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HelperNaviBar extends StatefulWidget {
  const HelperNaviBar({super.key});

  @override
  _HelperNaviBarState createState() => _HelperNaviBarState();
}

class _HelperNaviBarState extends State<HelperNaviBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          Selected(
            icon: Icons.bar_chart_rounded,
            label: "Stats",
            isSelected: _selectedIndex == 0,
            isEnd: 'Left',
            onTap: () {
              setState(() {
                _selectedIndex = 0;
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelperStatsPage()),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Container(color: Colors.black, width: 2),
          ),
          Selected(
            icon: Icons.money_rounded,
            label: "Orders",
            isSelected: _selectedIndex == 1,
            isEnd: 'Mid',
            onTap: () {
              setState(() {
                _selectedIndex = 1;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Container(color: Colors.black, width: 2),
          ),
          Selected(
            icon: Icons.warehouse_rounded,
            label: "Stocks",
            isSelected: _selectedIndex == 2,
            isEnd: 'Right',
            onTap: () {
              setState(() {
                _selectedIndex = 2;
              });
            },
          ),
        ],
      ),
    );
  }
}

class SwitchExample extends StatefulWidget {
  const SwitchExample({super.key});

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool light = true;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: light,
      activeColor: Colors.green,
      onChanged: (bool value) {
        setState(() {
          light = value;
        });
      },
    );
  }
}

class statsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const statsCard(
      {super.key,
      required this.icon,
      required this.title,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, size: 30),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PopularItems extends StatelessWidget {
  const PopularItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseService().getTopProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Map<String, dynamic>>? topItems = snapshot.data;
          if (topItems == null || topItems.isEmpty) {
            return const Text('No top products available.');
          } else {
            return Column(
              children: topItems.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> item = entry.value;
                return Column(
                  children: [
                    ListTile(
                      leading: Text(
                        (index + 1).toString(),
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      title: Text(
                        item['itemName'],
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "Quantity: ${item['quantity']}",
                        style: const TextStyle(
                          fontSize: 8,
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                );
              }).toList(),
            );
          }
        }
      },
    );
  }
}

class ShopRatings extends StatelessWidget {
  const ShopRatings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: DatabaseService().fetchFnbRatingsByOwner(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<String>? ratings = snapshot.data;
          if (ratings != null && ratings.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        ratings[0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${ratings[1]} Raters',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'DM Sans',
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      ratingBar(
                          '5', int.parse(ratings[2]) / int.parse(ratings[1])),
                      ratingBar(
                          '4', int.parse(ratings[3]) / int.parse(ratings[1])),
                      ratingBar(
                          '3', int.parse(ratings[4]) / int.parse(ratings[1])),
                      ratingBar(
                          '2', int.parse(ratings[5]) / int.parse(ratings[1])),
                      ratingBar(
                          '1', int.parse(ratings[6]) / int.parse(ratings[1])),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return const Text('No ratings data available.');
          }
        }
      },
    );
  }
}
