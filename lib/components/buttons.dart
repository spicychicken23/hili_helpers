import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hili_helpers/models/cart.dart';
import 'package:hili_helpers/models/promo.dart';
import 'package:hili_helpers/services/database_service.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.buttonText,
      this.isOutlined = false,
      required this.onPressed,
      this.width = 280});

  final String buttonText;
  final bool isOutlined;
  final Function onPressed;
  final double width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Material(
        borderRadius: BorderRadius.circular(30),
        elevation: 4,
        child: Container(
          width: 330,
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: isOutlined ? Colors.white : const Color(0xFF2367B1),
            border: Border.all(color: const Color(0xFF2367B1), width: 1.5),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: isOutlined ? const Color(0xFF2367B1) : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget accBtn(String image, BuildContext context, String nextPageId) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, nextPageId);
    },
    child: AspectRatio(
      aspectRatio: 2.62 / 3,
      child: Container(
        margin: const EdgeInsets.only(right: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(image),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              stops: const [0.1, 0.9],
              colors: [
                const Color(0xFF0C171D).withOpacity(.4),
                const Color(0xFF0C171D).withOpacity(.1),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget serviceIcon(String image, BuildContext context, String nextPageId) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, nextPageId);
    },
    child: Column(
      children: [
        Container(
          height: 80,
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              margin: const EdgeInsets.only(right: 15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(image),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.bottomRight,
                    stops: const [0.1, 0.9],
                    colors: [
                      const Color(0xFF0C171D).withOpacity(.4),
                      const Color(0xFF0C171D).withOpacity(.1),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 2),
        const Padding(
          padding: EdgeInsets.only(right: 15),
          child: Text(
            "text",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}

Widget allBtn(IconData icon, String label, VoidCallback onPressed) {
  return InkWell(
    onTap: () {},
    child: Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
          child: IconButton(
            icon: Icon(icon),
            onPressed: onPressed,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
      ],
    ),
  );
}

class NewsPromo extends StatelessWidget {
  const NewsPromo({super.key, required this.promo});
  final Promo promo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(promo.Icon),
              radius: 25,
            ),
            title: Text(
              promo.Title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              promo.Description,
              style: const TextStyle(
                fontSize: 8,
              ),
            ),
          ),
          const Divider(
            thickness: 1,
          ),
        ],
      ),
    );
  }
}

class actHistory extends StatelessWidget {
  const actHistory(
      {Key? key, required this.order, required this.databaseService})
      : super(key: key);

  final cart order;
  final DatabaseService databaseService;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(_getIcon(order.shop_Id)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: FutureBuilder<String?>(
              future: databaseService.getShopName(order.shop_Id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Text(
                  snapshot.data!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            subtitle: Text(
              order.order_date.toDate().toString(),
              style: const TextStyle(
                fontSize: 8,
              ),
            ),
            trailing: Text(
              order.subtotal.toString(),
              style: const TextStyle(
                fontSize: 8,
              ),
            ),
          ),
          const Divider(
            thickness: 1,
          ),
        ],
      ),
    );
  }
}

class actOnGoing extends StatelessWidget {
  const actOnGoing(
      {Key? key, required this.order, required this.databaseService})
      : super(key: key);

  final cart order;
  final DatabaseService databaseService;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          Container(
            height: 80,
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                margin: const EdgeInsets.only(right: 15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(_getIcon(order.shop_Id)),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      stops: const [0.1, 0.9],
                      colors: [
                        const Color(0xFF0C171D).withOpacity(.4),
                        const Color(0xFF0C171D).withOpacity(.1),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Text(
              _getStatus(order.order_date),
              style: TextStyle(
                color: Colors.black87,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

String _getStatus(Timestamp time) {
  Timestamp currentTime = Timestamp.now();

  int differenceInSeconds = time.seconds - currentTime.seconds;

  if (differenceInSeconds <= 0) {
    return 'On Going';
  } else if (differenceInSeconds <= 24 * 3600) {
    DateTime orderDateTime =
        DateTime.fromMillisecondsSinceEpoch(time.seconds * 1000);
    return '${orderDateTime.hour}:${orderDateTime.minute}';
  } else {
    DateTime orderDate =
        DateTime.fromMillisecondsSinceEpoch(time.seconds * 1000);
    return '${orderDate.day}/${orderDate.month}/${orderDate.year}';
  }
}

String _getIcon(String shopId) {
  if (shopId.startsWith('F')) {
    return 'lib/images/FNB ICON.png';
  } else if (shopId.startsWith('D')) {
    return 'lib/images/DOM ICON.png';
  } else if (shopId.startsWith('V')) {
    return 'lib/images/VEH ICON.png';
  } else {
    return 'lib/images/EDU ICON.png';
  }
}
