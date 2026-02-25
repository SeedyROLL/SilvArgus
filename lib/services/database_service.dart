import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/scan_history.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'silvargus_history.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE scan_history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        imagePath TEXT,
        diseaseName TEXT,
        confidenceScore REAL,
        scanDate TEXT
      )
    ''');
  }

  Future<int> insertScan(ScanHistory scan) async {
    final db = await database;
    return await db.insert('scan_history', scan.toMap());
  }

  Future<List<ScanHistory>> getAllScans() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'scan_history',
      orderBy: 'scanDate DESC',
    );
    return List.generate(maps.length, (i) {
      return ScanHistory.fromMap(maps[i]);
    });
  }
}
