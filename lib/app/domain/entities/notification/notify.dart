class Notify {
  final String notificationId;
  final String belongsTo;
  final String type;
  final String title;
  final String body;
  final int timestamp;

  Notify({
    required this.notificationId,
    required this.belongsTo,
    required this.type,
    required this.title,
    required this.body,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'notificationId': notificationId,
      'belongsTo': belongsTo,
      'type': type,
      'title': title,
      'body': body,
      'timestamp': timestamp
    };
  }

  factory Notify.fromMap(Map<String, dynamic> map) {
    return Notify(
      notificationId: map['notificationId'] ?? '',
      belongsTo: map['belongsTo'] ?? '',
      type: map['type'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      timestamp: map['timestamp'] ?? 0,
    );
  }
}
