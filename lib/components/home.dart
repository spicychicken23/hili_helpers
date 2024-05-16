import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hili_helpers/models/promo.dart';
import 'package:hili_helpers/pages/services_details_page.dart';
import '../models/servicesLists.dart';

Widget accBtn(
    String image, BuildContext context, String nextPageId, String pageType) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, nextPageId, arguments: pageType);
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
  const NewsPromo({super.key, required this.promo, this.fnbs});
  final Promo promo;
  final fnb? fnbs;
  Future<fnb?> fetchFnbByShopId(String shopId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('fnbLists')
          .where('ID', isEqualTo: shopId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        return fnb.fromJson(doc.data() as Map<String, Object?>);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching fnb: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        fnb? fetchedFnb = await fetchFnbByShopId(promo.Shop_ID);
        if (fetchedFnb != null) {
          String pageType = promo.Shop_ID.substring(0, 3);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FnbDetailsPage(
                Fnb: fetchedFnb,
                pageType: pageType,
              ),
            ),
          );
        }
      },
      child: Padding(
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
      ),
    );
  }
}
