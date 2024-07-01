import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:http/http.dart' as http;
import 'datacrud.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; // Add the http package

class Campaign extends DataCrud {
  final Map<String, dynamic> info;

  Campaign({required this.info}) {
    if (info.isEmpty) {
      throw ArgumentError('Campaign info cannot be empty.');
    }
  }

  static int nextId = 1; // Initialize counter to avoid conflicts

  factory Campaign.fromJson(Map<String, dynamic>? json) {
    final info = json?['info'] as Map<String, dynamic>?;
    if (info != null) {
      return Campaign(info: info);
    } else {
      throw Exception('Missing or invalid "info" field in JSON data');
    }
  }

  Map<String, dynamic> toMap() {
    return {'data': info}; // Return only the 'data' part
  }

  @override
  Future<String?> insertRecordOverride(Database db, String tableName) async {
    try {   
      // Create the campaign table if it doesn't exist
      await db.execute('''
        CREATE TABLE IF NOT EXISTS campaign (
          fld1 INTEGER PRIMARY KEY AUTOINCREMENT,
          fld2 TEXT NOT NULL,
          fld3 TEXT NOT NULL,
          fld4 TEXT NOT NULL,
          fld5 TEXT
        );
      ''');
      // Build the list of field names and placeholders for parameterized query
      final List<String> fieldNames = this.info.keys.toList();
      final List<String> placeholders = List.generate(fieldNames.length, (i) => '?');
      final insertSql = "INSERT INTO campaign (" + fieldNames.join(',') + ") VALUES (" + placeholders.join(',') + ")";
      // Bind data values securely using a list
      final List<dynamic> bindValues = fieldNames.map((name) => this.info[name]).toList();
      print("$insertSql, ${bindValues.join(', ')}");
      // Execute the parameterized query
      await db.rawInsert(insertSql, bindValues);
      return "$insertSql ${bindValues.join(', ')}";
    } catch (err) {
      print('Database errors: ${err}');
    }
    return null;
  }

static Future<List<Campaign>> fetchRandomCampaigns() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    if (response.statusCode == 200) {
      List<dynamic> users = jsonDecode(response.body);
      return List.generate(5, (index) {
        var user = users[index % users.length]; // Pick from the fetched users
        var voteOptions = ['YES', 'NO', 'Abstain'];
        var vote = voteOptions[index % voteOptions.length];
        return Campaign(info: {
          'fld2': user['name'],
          'fld3': 'Campaign${index + 1}',
          'fld4': vote,
          'fld5': 'Campaign${index + 1}_$vote'
        });
      });
    } else {
      throw Exception('Failed to load data');
    }
  }  
}

void main() async {
  List<Campaign> pList = [];
//  pList.add(Campaign.fromJson({"info": {"fld2": "Paul Dunkirk", "fld3": "Campaign1", "fld4": "yes", "fld5": "Campaign1_Yes"}}));
//  pList.add(Campaign.fromJson({"info": {"fld2": "Rebecca Pauline", "fld3": "Campaign2", "fld4": "No", "fld5": "Campaign2_No"}}));

  try {
    // Fetch random campaigns from the API
    pList = await Campaign.fetchRandomCampaigns();

    final dataCrud = DataCrud();
    await dataCrud.initDatabase();
    Database dd = dataCrud.db;

    for (var camp in pList) {
      await camp.insertRecordOverride(dd, "campaign");
    }
    print("Data saved to SQLite database");
    print("Now read-back data from SQLite database");
    List<Map<String, dynamic>> pL = await dataCrud.getRecords('campaign');
    if (pL.isNotEmpty) {
      for (var p in pL) {
        final id = p['fld1'];
        final data = p; // No need to decode
        print("Data for campaign: $id...");
        print("\tUser: ${data['fld2']}");
        print("\tCampaign_Desc: ${data['fld3']}");
        print("\tVote_for: ${data['fld4']}");
        print("\tRemarks: ${data['fld5']}");
      }
    }
  } catch (err) {
    print('Database errors: ${err}');
  }
}
