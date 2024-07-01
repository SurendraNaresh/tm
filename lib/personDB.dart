import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'datacrud.dart';

//import 'person.dart';
class CampaignDb extends DataCrud {
  @override
  Future<void> insertRecordOverride(String tableName, Map<String, dynamic> data) async {
    // Extract specific data fields from the map
    final userName = data['User_name'];
    final campaignDesc = data['campaign_desc'];
    final vote = data['vote'];
    final remark = data['remark'];

    // Get the next ID using the base class method
    final nextId = await DataCrud.getNextId(tableName);
    final ddb = DataCrud();
    // Insert data with extracted fields
    await ddb.execute(
      "INSERT INTO $tableName (id, fld1, fld2, fld3, fld4) VALUES (?, ?, ?, ?, ?)",
      [nextId, userName, campaignDesc, vote, remark],
    );
  }
}

class PersonDb extends DataCrud {
  @override
  Future<void> insertRecordOverride(String tableName, Map<String, dynamic> data) async {
    // Extract specific data fields from the map
    final Name = data['Name'];
    final City = data['City'];
    final Age = data['Age'];
  
    // Get the next ID using the base class method
    final nextId = await DataCrud.getNextId(tableName);
    final ddb = DataCrud();
    // Insert data with extracted fields
    await ddb.execute(
      "INSERT INTO $tableName (id, fld1, fld2, fld3) VALUES (?, ?, ?, ?, ?)",
      [nextId, Name, City, Age],
    );
  }
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
class TestModule extends StatefulWidget {
  const TestModule({Key? key}) : super(key: key);

  @override
  State<TestModule> createState() => _TestModuleState();
}

class _TestModuleState extends State<TestModule> {
  final dataCrud = DataCrud();

  @override
  void initState() {
    super.initState();
    initDatabase();
  }

  Future<void> initDatabase() async {
    try {
      await dataCrud.initDatabase();
    } catch (error) {
      print('Error initializing database: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Module'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Create a Person object
                final person = Person.fromJson({
                  "info": {
                    "Name": "John Doe",
                    "City": "New York",
                    "Age": 30,
                  },
                });

                try {
                  // Insert the Person data into the database
                  await dataCrud.insertRecord('person', person.toMap());
                  print('Person data inserted successfully');
                } catch (error) {
                  print('Error inserting person: $error');
                }
              },
              child: const Text('Insert Person'),
            ),
          ],
        ),
      ),
      
    );
  }
}

void main() async{
  List<Person> pList = [];
    pList.add(Person.fromJson({"info":{"Name":"Paul Dunkirk", "City":"Bangalore","Age": 45}}));
    pList.add(Person.fromJson({"info":{"Name":"Brad Simcox", "City":"Ontaria", "Age": 23}}));
    pList.add(Person.fromJson({"info":{"Name":"Manoj Damodar" "Pauline", "City":"Gwalior", "Age":34}}));
  pList.add(Person.fromJson({"info":{"Name":"Rebecca Pauline", "City":"Nevada", "Age": 32}}));

  runApp(TestModule());

}