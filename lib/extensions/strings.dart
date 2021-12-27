extension LongStrings on String {
  void printLongString() {
    final RegExp pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern
        .allMatches(this)
        .forEach((RegExpMatch match) => print(match.group(0)));
  }
}
