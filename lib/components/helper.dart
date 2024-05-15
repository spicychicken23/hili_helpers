import 'package:flutter/material.dart';
import 'package:hili_helpers/pages/Helper_stats_page.dart';

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
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, size: 30),
                const SizedBox(
                  width: 10,
                ),
                Column(
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

class popularItems extends StatelessWidget {
  const popularItems({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://drive.usercontent.google.com/download?id=1pE1R5WqUnL5Cfn5cVBhK8ppQD20LUGht'),
              radius: 20,
            ),
            title: Text(
              'Cendoi ABC',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              "The best ABC cendoi in the universe! Beli ler babes.",
              style: TextStyle(
                fontSize: 8,
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
