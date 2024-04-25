import 'package:flutter/material.dart';

Widget buildProgressBar(String label, double value) {
  return Row(
    children: [
      Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFamily: 'DM Sans',
        ),
      ),
      const SizedBox(width: 8),
      SizedBox(
        height: 5,
        width: 100,
        child: LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(
            Color(0xFFD3A877),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
      ),
    ],
  );
}
