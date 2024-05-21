extension StringExtension on String {
    String capitalize() {
      return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
    }
}

String capitalize(String s) {
  return s.capitalize();
}

String makePretty(String ugly) {
  List<String> words = ugly.replaceAll('-', ' ').replaceAll('\n', ' ').split(' ');
  for (int i = 0; i < words.length; i++) {
    words[i] = words[i].capitalize();
  }
  ugly = words.join(' ');
  return ugly;
}
