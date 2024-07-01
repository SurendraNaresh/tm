//import 'dart:ffi';
//import 'dart:indexed_db';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:flutter/foundation.dart';
//import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
//import 'newlogs.dart';
import 'sharedlog.dart';
import 'dart:io';
import 'dart:convert';

class DataCrud {
  static late Database _db;
  static int nxtId = 0; // Initialize counter to avoid conflicts
  final String appDocumentsDir = Directory.current.path; //await getApplicationDocumentsDirectory();
  var databaseFactory;
  late Logger? vlog = Logger("datacrud",'./dbLog.csv');

 DataCrud() {
    var path = './ddir/';
    // Initialize sqflite ffi database factory
    if (Platform.isLinux || Platform.isWindows){
      vlog?.addData("dbInfo", "Started Logging @:${appDocumentsDir}" + '/dbLog.csv');
      vlog?.writeLog();
      sqfliteFfiInit();
    }  
    if (kIsWeb) {
      // Change default factory on the web
      databaseFactory = databaseFactoryFfiWeb;
      path = './campaign_db.db';
    }
    else { databaseFactory = databaseFactoryFfi; }
  
  }
  /// Getter method to access the database instance (_db)
  Database get db {
    return _db; // Return the _db instance
  }  // Public method to initialize the database

  Future<dynamic> initDatabase() async {
    try {
        vlog = Logger('datacrud', p.join(appDocumentsDir,'./dbLog.csv'));
        _db = await _initDatabase();
        _db.execute('CREATE TABLE IF NOT EXISTS infotab(id INTEGER AUTO_INCREMENT PRIMARY KEY, data TEXT)');
        vlog?.addData("initDb", "Successfully created table: records in ${_db.toString()}");
        vlog?.writeLog();
    } 
    catch (error, stackTrace) {
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
  Future<Database> _initDatabase() async {
  //final dbPath = p.join(await getApplicationDocumentsDirectory(), './ddir/myDb.db');
  final dbPath = p.join(appDocumentsDir, './ddir/camp.db');
    return databaseFactory.openDatabase(dbPath);
  // Return the opened database
  }
  /// Dynamic insertRecord method that allows overriding in calling modules
  Future<void> insertRecord(String tableName, dynamic data) async {
    // Call the overridable method if it exists in the calling module
    // final overridenMethod = this.runtimeType.getDeclaredMethod('insertRecordOverride', [String, Map<String, dynamic>]);
    if (tableName.toLowerCase() != 'infotab' ) {
      await insertRecordOverride(_db, tableName);
      return;
    }
    // Default implementation if no override exists
    int nextRecordId = await getNextId(tableName);
    print("Inserting into $tableName: got nextId:= $nextRecordId for ...");
    print("${data}");
    await _db.rawInsert(
      "INSERT INTO $tableName (id, data) VALUES (?, ?)",
      ["${nextRecordId}", jsonEncode(data)], // Encode data as JSON
    );
  }
  Future<List<Map<String, dynamic>>> getRecords(String tabName) async {
    return await _db.query('$tabName') ?? [] ;
  }

  Future<void> deleteRecord(String tabName,int id) async {
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
    final myDb = DataCrud._db;
    print('running getNextId...@table:=${tableName}.....');
    try {
      final result = await myDb.rawQuery("SELECT count(id) as mxcount FROM $tableName");
      //print("Result type: ${result.runtimeType}, result=${result.toString()}");
      if (result.isNotEmpty) {
        // print("Got some values from database : ${result[0]}");
        // print(jsonEncode("${result[0]}"));
        final int? maxId = result[0]['mxcount'] as int?;
        return (maxId ?? 0)+1 ; // Return 1 if maxId is null (empty table)
      } else {
        return 1; // Start with ID 1 if the table is empty
      }
    } catch (e) {
      print("Error while retrieving max ID: $e");
      rethrow; // Rethrow the error for proper handling
    }
  } 

  // Overridable method for custom insertRecord logic in calling modules
  // This method can be defined in the calling module to customize the
// insertion process based on specific requirements.
 // @protected
  Future<void> insertRecordOverride(Database dbt, String tableName) async {
    // Implement your custom insertion logic here
    throw UnimplementedError('insertRecordOverride is not implemented in DataCrud');
  }
  execute(String s, List list) {}
}

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
    //return {'Person-$id': info}; // Always use "Person-$id" for unique key
  }
}
void main() async{
  List<Person> pList = [];
    pList.add(Person.fromJson({"info":{"Name":"Paul Dunkirk", "City":"Bangalore","Age": 45}}));
    pList.add(Person.fromJson({"info":{"Name":"Brad Simcox", "City":"Ontario", "Age": 26}}));
    pList.add(Person.fromJson({"info":{"Name":"Manoj Koshto", "City":"Gwalior", "Age":39}}));
    pList.add(Person.fromJson({"info":{"Name":"Rebecca Pauline", "City":"Nevada", "Age": 32}}));
  try {
    final dataCrud = DataCrud();
    Database dd= await dataCrud.initDatabase();
    // Insert or replace the record in the database
    //pList.forEach((p) => dataCrud.insertRecord('infotab',p.info.toString()));
    print("Data saved to SQLite database");
    print("Now read-back data from SQLite database");
    List<Map<String, dynamic>> pL = await dataCrud.getRecords('person');
    if (pL != Null) {
      pL.forEach((p) {
        //print (p.toString());
          final id = p?['id'];
          final data = jsonDecode(p['data']);
         print("Data for person: $id...");
         print("\tName: ${data['Name']}");
         print("\tCity: ${data['City']}");
         print("\tAge: ${data['Age']}");
      });
    }
  }catch(err){
    print('Database errors: ${err}');
  }
}
