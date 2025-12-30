import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class MoreApps extends StatelessWidget {
  const MoreApps({super.key});

  final List<Map<String, String>> apps = const [
    {
      "name": "Boby",
      "image": "assets/icon/icon.jpg",
      "url": "https://apps.apple.com/hn/app/boby/id6753878717",
      "description":
          "The best app to learn and practice new English words — learn about numbers, animals, colors, and much more!.You’ll also be able to practice math, and there are games like word searches that help you read and remember even more new words you’ve learned.",
    },
    {
      "name": "Amauta",
      "image": "assets/amauta.jpg",
      "url": "https://apps.apple.com/hn/app/amauta/id6670520429",
      "description":
          "It’s an app for more advanced math topics such as free fall, triangle calculations using the Pythagorean theorem, the law of sines, and the law of cosines. It can also perform unit conversions like meters, yards, kilometers, etc. It calculates the area and volume of common shapes and performs electrical calculations for resistors in series and parallel.",
    },
    {
      "name": "Four Images",
      "image": "assets/four_images.jpg",
      "url": "https://apps.apple.com/hn/app/four-images/id6745151375",
      "description":
          "Four Images is a puzzle game where four famous pictures of places appear, and you have to guess the location. It’s fun and helps you learn about general culture and geography.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var app in apps)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  // Share the app URL
                  Share.share(
                    'Check out ${app['name']} on the App Store: ${app['url']}',
                    subject:
                        '${app['name']} - ${app['description']?.split('.').first}...',
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          app["image"]!,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              app["name"]!,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              app["description"]!,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Colors.black54,
                                    height: 1.2,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.share, color: Colors.green, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
