import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Functions {
  //shw message
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static Future<void> openUrlExternal(String url) async {
    final ok = await launchUrlString(url);
    if (!ok) {
      throw Exception('Could not launch $url');
    }
  }
}
