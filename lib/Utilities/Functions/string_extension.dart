extension StringExtension on String {
    String capitalize() {
      return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
    }
}

String makePretty(String ugly) {
  List<String> words = ugly.replaceAll('-', ' ').split(' ');
  for (int i = 0; i < words.length; i++) {
    words[i] = words[i].capitalize();
  }
  ugly = words.join(' ');
  return ugly.replaceAll('\n', ' ');
}
