import 'dart:async';
import 'dart:io';
import 'package:assesment/database/assessmentdb.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final String tableName = 'images';
  static final String fileName = 'fileName';
  static final String batchId = 'batchId';
  static final String priority = 'priority';
  static final String syncstatus = 'syncstatus';
  static final String type = 'type';
  static final String studentCode = 'studentCode';

  static DatabaseHelper _databaseHelper;
  static Database _database;

  DatabaseHelper._instance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._instance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDatabase();
    }
    return _database;
  }

  Future<Database> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = directory.path + '/imageDb.db';
    print('dbpath : $dbPath');
    return await openDatabase(dbPath, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int verion) {
    Future result = db.execute(
        'CREATE TABLE $tableName ($fileName TEXT PRIMARY KEY,$batchId TEXT,$priority INTEGER,$syncstatus INTEGER,$type TEXT,$studentCode TEXT)');
    return result;
  }

  Future<int> insertData(AssessmentDb assmntdb) async {
    Database db = await this.database;
    Future<int> result = db.insert('$tableName', assmntdb.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<int> updateData(AssessmentDb assessmentDb) async {
    Database db = await this.database;
    return await db.update('$tableName', assessmentDb.toMap(),
        where: '$batchId=?,$fileName=?',
        whereArgs: [assessmentDb.batchId, assessmentDb.fileName]);
  }

  Future<List<Map<String, dynamic>>> getDb() async {
    Database db = await this.database;
    return await db.rawQuery('SELECT * FROM $tableName');
  }

  Future<int> getCount() async {
    Database db = await this.database;

    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT COUNT(*) FROM $tableName');
    int count = Sqflite.firstIntValue(result);
    return count;
  }

  Future<List<AssessmentDb>> fetchData() async {
    List<AssessmentDb> assessmentList = List<AssessmentDb>();
    List<Map<String, dynamic>> result = await getDb();
    int count = await getCount();
    if (result != null) {
      for (int i = 0; i < count; i++)
        assessmentList.add(AssessmentDb.fromMap(result[i]));
    }

    return assessmentList;
  }
}
