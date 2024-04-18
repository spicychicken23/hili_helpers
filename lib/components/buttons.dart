import 'package:flutter/material.dart';
import 'package:hili_helpers/models/promo.dart';
import 'package:hili_helpers/models/fnbLists.dart';
import 'package:hili_helpers/pages/FNB_Details_page.dart';

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
        /* 
          Text(
            label,
            style: TextStyle(color: Colors.blue),
          ),
          */
      ],
    ),
  );
}

class NewsPromo extends StatelessWidget {
  //const NewsPromo({super.key});
  const NewsPromo({super.key, required this.promo});
  final Promo promo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
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
            //trailing: Text('F&B'),
          ),
          const Divider(
            thickness: 1,
          ),
        ],
      ),
    );
  }
}

// ignore: camel_case_types
class fnbListing extends StatelessWidget {
  const fnbListing({Key? key, required this.fnbs}) : super(key: key);

  final fnb fnbs;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NextPage(Fnb: fnbs),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            ListTile(
              leading: const CircleAvatar(
                radius: 25,
              ),
              title: Text(
                fnbs.Name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Row(
                children: [
                  const Icon(
                    Icons.star,
                    size: 12,
                    color: Color(0xFFD3A877),
                  ),
                  Text(
                    fnbs.Rating.toString(),
                    style: const TextStyle(
                      fontSize: 8,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
              ),
              trailing: Text(
                fnbs.Category,
                style: const TextStyle(
                  color: Color(0xFFB3B3B3),
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
