import 'package:flutter/material.dart';

Widget titleAndDetail(
    String title, detail, CrossAxisAlignment crossAxisAlignment) {
  return Column(
    crossAxisAlignment: crossAxisAlignment,
    children: [
      Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      ),
      const SizedBox(height: 5,),
      Text(
        detail,
        style: const TextStyle(fontSize: 17),
      ),
    ],
  );
}