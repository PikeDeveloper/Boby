import 'package:flutter/material.dart';

class BadgeSettings extends StatelessWidget {
  const BadgeSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle style = TextStyle(
      fontSize: 20,
      color: const Color.fromARGB(255, 47, 121, 250),
      fontWeight: FontWeight.bold,
    );

    final List<Map<String, String>> data = [
      {"name": "Diamond", "image": "assets/dymond.png", "value": "90"},
      {"name": "Gold", "image": "assets/gold.png", "value": "80"},
      {"name": "Silver", "image": "assets/silver.png", "value": "50"},
      {"name": "Bronze", "image": "assets/bronze.png", "value": "0"},
    ];
    return Column(
      children: [
        SizedBox(height: 10),
        for (var element in data)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Image.asset(element["image"]!, width: 40, height: 40),
                SizedBox(width: 10),
                Text("Good answers: ", style: style),
                Text(">= " + element["value"]! + "%", style: style),
              ],
            ),
          ),
      ],
    );
  }
}
