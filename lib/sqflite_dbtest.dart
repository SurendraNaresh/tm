//import 'dart:indexed_db';
import 'dart:convert';
import 'dart:io' ;
import 'package:path/path.dart' as p;
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
//import 'package:path_provider/path_provider.dart';
class DataCrud {
  late Database _db;
  final String appDocumentsDir = Directory.current.path; //await getApplicationDocumentsDirectory();
  var databaseFactory;
 DataCrud() {
    // Initialize sqflite ffi database factory
    if (Platform.isLinux || Platform.isWindows){
      sqfliteFfiInit();
    }  
    databaseFactory = databaseFactoryFfi;
  }
  // Public method to initialize the database
  Future<dynamic> initDatabase() async {
    _db = await _initDatabase();
  }
  Future<dynamic> _initDatabase() async {
    return await databaseFactory.openDatabase(
      p.join(await appDocumentsDir, './ddir/camp.db'),
      // options: openDatabaseOptions(
      // onCreate: (db, version) {
      //   return db.execute(
      //     'CREATE TABLE records(id INTEGER AUTOINCREMENT, PRIMARY KEY, info TEXT)',
      //   );
      // }),
      //version: 1,
    );
  }

  Future<void> insertRecord(String data) async {
    await _db.insert(
      'records',
      {'data': data},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getRecords() async {
    return await _db.query('records');
  }

  Future<void> deleteRecord(int id) async {
    await _db.delete(
      'records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllRecords() async {
    await _db.delete('records');
  }
}
class Person {
  final int id;
  final Map<String, dynamic>? info;

  Person(this.info) : id = 0; // Assuming auto-increment
  //factory Person.fromJson(Map<String, dynamic> json) => Person(json['info'] as Map<String, dynamic>);
  factory Person.fromJson(Map<String, dynamic>? json){
    final info=json?['info'] as Map<String, dynamic>?; // use a nullable type
    if (info != null) {
      return Person(info);
    } else {
      // Handle the case where "info" is missing or null (throw exception, return default, etc.)
      throw Exception('Missing or invalid "info" field in JSON data');
    }
  }
  String toMap() => {'Person-${id}': info}.toString();
}
Future main() async {
  // Init ffi loader if needed.
  var db;
  try{
    sqfliteFfiInit();

    var databaseFactory = databaseFactoryFfi;
    final Directory appDocumentsDir = Directory.current;   //await getApplicationDocumentsDirectory();
    
    //Create path for database
    String dbPath = p.join(appDocumentsDir.path, "ddir", "myDb.db");
    db = await databaseFactory.openDatabase(
      dbPath,
    );

    await db.execute('''
    CREATE TABLE IF NOT EXISTS Product (
        id INTEGER PRIMARY KEY,
        title TEXT
    )
    ''');
    await db.insert('Product', <String, Object?>{'title': 'Product 1'});
    await db.insert('Product', <String, Object?>{'title': 'Product 1'});

    var result = await db.query('Product');
    print(result);
    // prints [{id: 1, title: Product 1}, {id: 2, title: Product 1}]
    await db.close();
  }catch(err){
    print("Errors encounterd: ${err}");
  }
  var pjson =  { 'info':{"Name":"Anita", "City":"Madrid","Age": 36}, };
  var p1 = Person.fromJson(pjson);
  
  print("Name: ${p1.info?['Name']}" );
  print("City:${p1.info?['City']} " );
  print("Age:${p1.info?['Age']} " );
  //final p2 = Person.fromJson({"info":{"Name":"Chad", "City":"Nairobi", "Age": 43}});
  try {
    final dataCrud = DataCrud();
	  db = await dataCrud.initDatabase();
    await db.execute('''
    CREATE TABLE IF NOT EXISTS records (
        id INTEGER AUTOINCREMENT PRIMARY KEY,
        info TEXT
    )
    ''');
    // Insert or replace the record in the database
    await dataCrud.insertRecord(p1.toMap());
    //await dataCrud.insertRecord(p2.toMap());
	  print("Data saved to SQLite database");

  }catch(err){
    print('Database errors: ${err}');
  }
}
