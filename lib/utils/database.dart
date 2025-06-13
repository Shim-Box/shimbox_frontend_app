// utils/database.dart

import 'package:sqflite/sqflite.dart'; // sqflite 패키지 임포트
import 'package:path/path.dart'; // path 패키지 임포트
import '../../models/signup_data.dart'; // SignupData 임포트
import '../../utils/api_service.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('signup.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath(); // path 패키지에서 제공
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    ); // sqflite에서 제공
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT,
        password TEXT,
        name TEXT,
        birth TEXT,
        phoneNumber TEXT,
        residence TEXT,
        height INTEGER,
        weight INTEGER,
        licenseImage TEXT,
        career TEXT,
        averageWorking TEXT,
        averageDelivery TEXT,
        bloodPressure TEXT
      )
    ''');
  }

  // 사용자 삽입 메서드
  Future<int> insertUser(SignupData data) async {
    try {
      final db = await DatabaseHelper.instance.database;
      return await db.insert(
        'users',
        data.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Insert error: $e');
      rethrow;
    }
  }

  // 사용자 조회 메서드
  Future<SignupData?> getUser(String email, String password) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final result = await db.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
      );
      if (result.isNotEmpty) {
        return SignupData()..fromJson(result.first);
      }
      return null;
    } catch (e) {
      print('Query error: $e');
      rethrow;
    }
  }
}
