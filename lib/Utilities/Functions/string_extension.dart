extension StringExtension on String {
    String capitalize() {
      return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
    }
}

String makePretty(String ugly) {
  return ugly.replaceAll('\n', ' ');
}
