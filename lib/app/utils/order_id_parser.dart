class OrderIdParser {
  static String parse(String orderId) {
    if (orderId.isEmpty) {
      return '';
    }
    if (orderId.length < 8) {
      return orderId;
    }
    return orderId.substring(0, 8);
  }
}
