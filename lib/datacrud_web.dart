import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_sqlite/web_sqlite.dart'; // Use web_sqlite for web

class DataCrud {
  static late Database _db;
  static int nxtId = 0;
  late Logger? vlog = Logger("datacrud", 'dbLog.csv');

  DataCrud() {
    // No need for web-specific database factory setup here (handled by web_sqlite)
  }

  /// Getter method to access the database instance (_db)
  Database get db {
    return _db;
  }

  // Public method to initialize the database
  Future<dynamic> initDatabase() async {
    try {
      _db = await openDatabase(
        'camp.db',
        version: 1, // Specify a version for database schema changes
        onCreate: (db, version) async {
          await db.execute(
              'CREATE TABLE IF NOT EXISTS infotab(id INTEGER PRIMARY KEY AUTOINCREMENT, data TEXT)');
          vlog?.addData("initDb", "Successfully created table: records in ${_db.toString()}");
          vlog?.writeLog();
        },
      );
    } catch (error, stackTrace) {
      vlog?.addData('dbErrors:', jsonEncode({
        "data": {
          "db_name": _db.toString(),
          "_initDB": error.toString(),
          "Errors": stackTrace.toString(),
        }
      }));
      vlog?.writeLog();
      rethrow; // Rethrow the exception to signal failure
    }
  }

  Future<List<Map<String, dynamic>>> getRecords(String tabName) async {
    return await _db.query('$tabName') ?? [];
  }

  Future<void> deleteRecord(String tabName, int id) async {
    await _db.delete(
      '$tabName',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllRecords(String tabName) async {
    await _db.delete('$tabName');
  }

  static Future<int> getNextId(String tableName) async {
    final result = await _db.rawQuery("SELECT count(id) as mxcount FROM $tableName");
    if (result.isNotEmpty) {
      final int? maxId = result[0]['mxcount'] as int?;
      return (maxId ?? 0) + 1; // Return 1 if maxId is null (empty table)
    } else {
      return 1; // Start with ID 1 if the table is empty
    }
  }

  // No overridable insertRecordOverride needed for web_sqlite
}

// No Person class or insertRecordOverride method needed for web implementation

class Person {
  final int id;
  final Map<String, dynamic> info;
  Person({required this.info}) : id = 0 { // Use static counter for ID
    if (info.isEmpty) {
      throw ArgumentError('Person info cannot be empty.');
    }
  }

  static int nextId = 1; // Initialize counter to avoid conflicts
  factory Person.fromJson(Map<String, dynamic>? json) {
    final info = json?['info'] as Map<String, dynamic>?;
    if (info != null) {
      return Person(info: info);
    } else {
      throw Exception('Missing or invalid "info" field in JSON data');
    }
  }

  Map<String, dynamic> toMap() {
    return {'data': info}; // Return only the 'data' part
  }
}

void main() async {
  List<Person> pList = [];
  pList.add(Person.fromJson({"info": {"Name": "Paul Dunkirk", "City": "Bangalore", "Age": 45}}));
  pList.add(Person.fromJson({"info": {"Name": "Rebecca Pauline", "City": "Nevada", "Age": 32}}));

  try {
    final dataCrud = DataCrud();
    await dataCrud.initDatabase();
    for (var p in pList) {
      await dataCrud.insertRecord('infotab', p.info);
    }
    print("Data saved to SQLite database");
    print("Now read-back data from SQLite database");
    List<Map<String, dynamic>> pL = await dataCrud.getRecords('infotab');
    if (pL.isNotEmpty) {
      for (var p in pL) {
        final id = p['id'];
        final data = jsonDecode(p['data']);
        print("Data for person: $id...");
        print("\tName: ${data['Name']}");
        print("\tCity: ${data['City']}");
        print("\tAge: ${data['Age']}");
      }
    }
  } catch (err) {
    print('Database errors: $err');
  }
}
