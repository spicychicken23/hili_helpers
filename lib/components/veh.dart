import 'package:flutter/material.dart';
import 'package:hili_helpers/pages/VEH_Details_page.dart';

class vehListing extends StatelessWidget {
  const vehListing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VehDetailsPage(),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            ListTile(
              leading: ClipOval(
                child: Image.network(
                  'https://drive.usercontent.google.com/download?id=1pE1R5WqUnL5Cfn5cVBhK8ppQD20LUGht',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              title: const Text(
                'Ali Tayar',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 12,
                    color: Color(0xFFD3A877),
                  ),
                  Text(
                    '3.85',
                    style: TextStyle(
                      fontSize: 8,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
              ),
              trailing: const Text(
                'Secondhand Tires',
                style: TextStyle(
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
