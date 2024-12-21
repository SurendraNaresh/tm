import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random User PDF',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> users = [];
  bool isLoading = false;

  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse('https://randomuser.me/api/?results=10'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        users = data['results'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch users')),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> saveAsPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text('Random Users', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 20),
          pw.ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Name: ${user['name']['first']} ${user['name']['last']}'),
                  pw.Text('Age: ${user['dob']['age']}'),
                  pw.Text('Location: ${user['location']['city']}, ${user['location']['country']}'),
                  pw.Divider(),
                ],
              );
            },
          ),
        ],
      ),
    );

    final directory = await getDownloadsDirectory();
    final path = directory?.path;

    if (path != null) {
      final file = File('$path/random_users.pdf');
      await file.writeAsBytes(await pdf.save());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF saved to Downloads folder: random_users.pdf')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to find Downloads folder')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random User PDF'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user['picture']['thumbnail']),
                  ),
                  title: Text('${user['name']['first']} ${user['name']['last']}'),
                  subtitle: Text('${user['location']['city']}, ${user['location']['country']}'),
                  trailing: Text('Age: ${user['dob']['age']}'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (users.isEmpty) {
            await fetchUsers();
          } else {
            await saveAsPDF();
          }
        },
        child: Icon(users.isEmpty ? Icons.download : Icons.picture_as_pdf),
      ),
    );
  }
}

Future<Directory?> getDownloadsDirectory() async {
  if (Platform.isAndroid) {
    return await getExternalStorageDirectory();
  } else if (Platform.isIOS || Platform.isMacOS) {
    return await getApplicationDocumentsDirectory();
  } else {
    return null;
  }
}
