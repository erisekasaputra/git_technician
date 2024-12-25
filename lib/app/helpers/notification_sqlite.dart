import 'package:santai_technician/app/domain/entities/notification/notify.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NotificationSqlite {
  static final NotificationSqlite instance = NotificationSqlite._init();
  static Database? _database;

  NotificationSqlite._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notifications.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notifications (
        notificationId TEXT PRIMARY KEY,
        belongsTo TEXT NOT NULL,
        type TEXT NOT NULL,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        timestamp INTEGER
      )
    ''');
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }

  Future<int> insertNotification(Notify notification) async {
    final db = await database;

    return await db.insert(
      'notifications',
      notification.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Notify?> getNotificationByUserId(String userId) async {
    final db = await database;

    final result = await db.query(
      'notifications',
      where: 'belongsTo = ?',
      whereArgs: [userId],
    );

    if (result.isNotEmpty) {
      return Notify.fromMap(result.first);
    }
    return null;
  }

  Future<List<Notify>> getNotificationsByUserId(String userId) async {
    final db = await database;

    final result = await db.query('notifications',
        where: 'belongsTo = ?', whereArgs: [userId], orderBy: 'timestamp ASC');

    return result.map((json) => Notify.fromMap(json)).toList();
  }

  Future<bool> anyNotificationByNotificationId(String notificationId) async {
    final db = await database;

    // Query to fetch the latest conversation by orderId
    final result = await db.query(
      'notifications',
      where: 'notificationId = ?',
      whereArgs: [notificationId],
      limit: 1, // Limit the result to the latest record
    );

    return result.isNotEmpty;
  }

  Future<Notify?> getLatestNotificationsByUserId(String userId) async {
    final db = await database;

    // Query to fetch the latest conversation by orderId
    final result = await db.query(
      'notifications',
      where: 'belongsTo = ?',
      whereArgs: [userId],
      orderBy: 'timestamp ASC', // Order by timestamp in descending order
      limit: 1, // Limit the result to the latest record
    );

    // If no results found, return null
    if (result.isEmpty) return null;

    // Convert the first result to ConversationResponse
    return Notify.fromMap(result.first);
  }
}
