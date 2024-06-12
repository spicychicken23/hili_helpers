import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hili_helpers/models/cart.dart';
import 'package:hili_helpers/services/database_service.dart';

class actHistory extends StatelessWidget {
  const actHistory(
      {Key? key,
      required this.order,
      required this.databaseService,
      double? rating})
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
              order.subtotal.toStringAsFixed(2),
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
              style: const TextStyle(
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

