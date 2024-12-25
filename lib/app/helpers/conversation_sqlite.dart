import 'package:santai_technician/app/services/chat_signalr_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ConversationSqlite {
  static final ConversationSqlite instance = ConversationSqlite._init();
  static Database? _database;

  ConversationSqlite._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('conversations.db');
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
      CREATE TABLE conversations (
        messageId TEXT PRIMARY KEY,
        orderId TEXT NOT NULL,
        originUserId TEXT NOT NULL,
        destinationUserId TEXT NOT NULL,
        text TEXT NOT NULL,
        attachment TEXT,
        replyMessageId TEXT,
        replyMessageText TEXT,
        timestamp INTEGER NOT NULL
      )
    ''');
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }

  Future<int> insertConversation(ConversationResponse conversation) async {
    final db = await database;

    return await db.insert(
      'conversations',
      conversation.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<ConversationResponse?> getConversationById(String messageId) async {
    final db = await database;

    final result = await db.query(
      'conversations',
      where: 'messageId = ?',
      whereArgs: [messageId],
    );

    if (result.isNotEmpty) {
      return ConversationResponse.fromMap(result.first);
    }
    return null;
  }

  Future<int> updateConversation(ConversationResponse conversation) async {
    final db = await database;

    return await db.update(
      'conversations',
      conversation.toMap(),
      where: 'messageId = ?',
      whereArgs: [conversation.messageId],
    );
  }

  Future<int> deleteConversation(String messageId) async {
    final db = await database;

    return await db.delete(
      'conversations',
      where: 'messageId = ?',
      whereArgs: [messageId],
    );
  }

  Future<List<ConversationResponse>> getConversationsByOrderId(
      String orderId) async {
    final db = await database;

    final result = await db.query('conversations',
        where: 'orderId = ?', whereArgs: [orderId], orderBy: 'timestamp ASC');

    return result.map((json) => ConversationResponse.fromMap(json)).toList();
  }

  Future<bool> anyConversationByMessageId(String messageId) async {
    final db = await database;

    // Query to fetch the latest conversation by orderId
    final result = await db.query(
      'conversations',
      where: 'messageId = ?',
      whereArgs: [messageId],
      limit: 1, // Limit the result to the latest record
    );

    return result.isNotEmpty;
  }

  Future<ConversationResponse?> getLatestConversationByOrderId(
      String orderId) async {
    final db = await database;

    // Query to fetch the latest conversation by orderId
    final result = await db.query(
      'conversations',
      where: 'orderId = ?',
      whereArgs: [orderId],
      orderBy: 'timestamp ASC', // Order by timestamp in descending order
      limit: 1, // Limit the result to the latest record
    );

    // If no results found, return null
    if (result.isEmpty) return null;

    // Convert the first result to ConversationResponse
    return ConversationResponse.fromMap(result.first);
  }
}
