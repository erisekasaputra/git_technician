import 'package:uuid/uuid.dart';

class UniqueIdentifier {
  static String generateId() {
    return '${DateTime.now().toUtc().millisecondsSinceEpoch}-${const Uuid().v4().toString()}';
  }
}
