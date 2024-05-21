import 'package:flutter/services.dart' show rootBundle;

Future<String> loadAsset(String url) async {
  return await rootBundle.loadString(url);
}