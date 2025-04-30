import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/insect_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('bugfinder.db');
    return _database!;
  }

  Future<Database> _initDB(String path) async {
    final dbPath = await getDatabasesPath();
    final dbLocation = join(dbPath, path);

    return await openDatabase(
      dbLocation,
      version: 2, // Верзија 2 за да се осигура дека имаме сите колони
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE insects(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        imageUrl TEXT,
        scientificName TEXT,
        activeTime TEXT,
        location TEXT,
        dangerous INTEGER,
        diet TEXT,
        lastSeenTime TEXT,
        insectType TEXT,
        flowerPreference TEXT,
        lifespan TEXT,
        frequency TEXT,
        activityPeriod TEXT,
        abilities TEXT,
        size REAL,
        regions TEXT
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE insects ADD COLUMN insectType TEXT;');
      await db.execute('ALTER TABLE insects ADD COLUMN flowerPreference TEXT;');
      await db.execute('ALTER TABLE insects ADD COLUMN lifespan TEXT;');
      await db.execute('ALTER TABLE insects ADD COLUMN frequency TEXT;');
      await db.execute('ALTER TABLE insects ADD COLUMN activityPeriod TEXT;');
      await db.execute('ALTER TABLE insects ADD COLUMN abilities TEXT;');
      await db.execute('ALTER TABLE insects ADD COLUMN size REAL;');
      await db.execute('ALTER TABLE insects ADD COLUMN regions TEXT;');
    }
  }

  Future<int> addInsect(InsectModel insect) async {
    final db = await instance.database;
    try {
      return await db.insert('insects', insect.toMap());
    } catch (e) {
      print("Error adding insect: $e");
      rethrow;
    }
  }

  Future<List<InsectModel>> getInsects() async {
    final db = await instance.database;
    try {
      final result = await db.query('insects');
      return result.map((json) => InsectModel.fromJson(json)).toList();
    } catch (e) {
      print("Error fetching insects: $e");
      return [];
    }
  }
  Future<void> deleteInsect(String name) async {
    final db = await database;
    await db.delete(
      'insects',
      where: 'name = ?',
      whereArgs: [name],
    );
  }
}
