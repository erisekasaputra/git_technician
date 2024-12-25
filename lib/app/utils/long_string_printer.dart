void printLongString(String text) {
  const int chunkSize = 500; // Set the maximum chunk size
  for (int i = 0; i < text.length; i += chunkSize) {
    // ignore: avoid_print
    print('--------------------------------------------------------');
    // ignore: avoid_print
    print(text.substring(
        i, i + chunkSize > text.length ? text.length : i + chunkSize));
    // ignore: avoid_print
    print('--------------------------------------------------------');
  }
}
