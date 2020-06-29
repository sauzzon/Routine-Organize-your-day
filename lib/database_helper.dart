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
  static final columnPersonName = 'personName';
  static final personNameTable = 'personNameTable';
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
    db.execute('''
        CREATE TABLE $personNameTable(
         $columnId INTEGER PRIMARY KEY,
       $columnPersonName TEXT NOT NULL)
    ''');
    return null;
  }

  //returns the primary key(int) automatically generated

  Future<int> insertPersonName(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(personNameTable, row);
  }

  Future<int> insertActivities(
      String personName, Map<String, dynamic> row) async {
    String woSpace = personName.replaceAll(' ', '');
    Database db = await instance.database;
    return await db.insert(woSpace, row);
  }

  Future<List<Map<String, dynamic>>> queryPersonNames() async {
    Database db = await instance.database;
    return await db.query(personNameTable);
  }

  Future<List<Map<String, dynamic>>> queryActivities(String table) async {
    Database db = await instance.database;
    String woSpace = table.replaceAll(' ', '');
    return await db.query(woSpace);
  }

  Future<int> update(
      String personName, int iD, Map<String, dynamic> row) async {
    Database db = await instance.database;
    String woSpace = personName.replaceAll(' ', '');
    return await db.update(woSpace, row, where: '$columnId=?', whereArgs: [iD]);
  }

  Future delete(String table) async {
    Database db = await instance.database;

    return await db.delete(personNameTable,
        where: '$columnPersonName=?', whereArgs: [table]);
  }

  Future deleteRoutine(String tableName) async {
    Database db = await instance.database;
    String woSpace = tableName.replaceAll(' ', '');
    db.execute('''
              DROP TABLE IF EXISTS $woSpace
    ''');
  }

  Future deleteActivity(String name, int iD) async {
    String woSpace = name.replaceAll(' ', '');
    Database db = await instance.database;
    return await db.delete(woSpace, where: '$columnId=?', whereArgs: [iD]);
  }

  Future createNewTable(String newTable) async {
    String woSpace = newTable.replaceAll(' ', '');
    Database db = await instance.database;
    db.execute('''
        CREATE TABLE $woSpace(
        $columnId INTEGER PRIMARY KEY,
        $columnactName TEXT NOT NULL,
        $columnInitial TEXT NOT NULL,
        $columnFinal TEXT NOT NULL)
    ''');
    print('New table $woSpace is created');
    return null;
  }
}
