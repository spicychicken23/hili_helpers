import 'package:flutter/material.dart';
import 'package:hili_helpers/models/promo.dart';
import 'package:hili_helpers/models/search.dart';
import 'package:hili_helpers/pages/services_details_page.dart';
import 'package:hili_helpers/services/database_service.dart';
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        fnb? fetchedFnb =
            await DatabaseService().fetchFnbByShopId(promo.Shop_ID);
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

class CustomSearchBar extends SearchDelegate {
  List<Shop> searchTerms = DatabaseService().fetchSearchTerms();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Shop>>(
      future: fetchFilteredShops(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Shop> matchQuery = snapshot.data ?? [];
          return ListView.builder(
            itemCount: matchQuery.length,
            itemBuilder: (context, index) {
              var result = matchQuery[index];
              return GestureDetector(
                onTap: () async {
                  fnb? fetchedFnb =
                      await DatabaseService().fetchFnbByShopId(result.id);
                  String pageType = result.id.substring(0, 3);
                  if (fetchedFnb != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FnbDetailsPage(Fnb: fetchedFnb, pageType: pageType),
                      ),
                    );
                  }
                },
                child: ListTile(
                  title: Text(result.name),
                ),
              );
            },
          );
        }
      },
    );
  }

  Future<List<Shop>> fetchFilteredShops(String query) async {
    List<Shop> filteredShops = searchTerms
        .where((shop) => shop.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return filteredShops;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Shop>>(
      future: fetchFilteredShops(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Shop> matchQuery = snapshot.data ?? [];
          return ListView.builder(
            itemCount: matchQuery.length,
            itemBuilder: (context, index) {
              var result = matchQuery[index];
              return GestureDetector(
                onTap: () async {
                  fnb? fetchedFnb =
                      await DatabaseService().fetchFnbByShopId(result.id);
                  String pageType = result.id.substring(0, 3);
                  if (fetchedFnb != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FnbDetailsPage(Fnb: fetchedFnb, pageType: pageType),
                      ),
                    );
                  }
                },
                child: ListTile(
                  title: Text(result.name),
                ),
              );
            },
          );
        }
      },
    );
  }
}
