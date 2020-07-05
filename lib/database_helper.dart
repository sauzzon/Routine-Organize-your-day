import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _dbName = 'myDatabase.db';
  static final _dbVersion = 1;
  static final columnId = 'id';
  static final columnactName = 'actName';
  static final columnInitial = 'init';
  static final columnFinal = 'fin';

  List<String> weekDays = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];
  //making a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initiateDatabase();
    return _database;
  }

  _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) {
    for (int i = 0; i < weekDays.length; i++) {
      String dayName = weekDays[i];
      db.execute('''
       CREATE TABLE $dayName(
        $columnId INTEGER PRIMARY KEY,
        $columnactName TEXT NOT NULL,
        $columnInitial TEXT NOT NULL,
        $columnFinal TEXT NOT NULL)
      ''');
    }
    return null;
  }

  //returns the primary key(int) automatically generated

  Future<int> insertActivities(String day, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(day, row);
  }

  Future<List<Map<String, dynamic>>> queryActivities(String day) async {
    Database db = await instance.database;
    return await db.query(day);
  }

  Future<int> update(String day, int iD, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.update(day, row, where: '$columnId=?', whereArgs: [iD]);
  }

  Future deleteActivity(String day, int iD) async {
    Database db = await instance.database;
    return await db.delete(day, where: '$columnId=?', whereArgs: [iD]);
  }
}
