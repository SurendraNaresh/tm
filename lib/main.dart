import 'dart:io';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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
  final TextEditingController recordController = TextEditingController(text: '10');

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers([int? count]) async {
    setState(() {
      isLoading = true;
    });

    final results = count ?? int.tryParse(recordController.text) ?? 10;
    final response = await http.get(Uri.parse('https://randomuser.me/api/?results=$results'));

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

    final bytes = await pdf.save();

    if (kIsWeb) {
      // For web: Create a downloadable link
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..target = '_blank'
        ..download = 'random_users.pdf'
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      // For other platforms: Save to custom path
      final directory = await getDownloadsDirectory();
      final path = directory?.path;

      if (path != null) {
        final file = File('$path/random_users.pdf');
        await file.writeAsBytes(bytes);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF saved to Downloads folder: random_users.pdf')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to find Downloads folder')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random User PDF'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: recordController,
                    decoration: InputDecoration(
                      labelText: 'Number of Records',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    final count = int.tryParse(recordController.text);
                    if (count != null && count > 0) {
                      fetchUsers(count);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter a valid number')),
                      );
                    }
                  },
                  child: Text('Refresh'),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
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
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                final count = int.tryParse(recordController.text);
                                if (count != null && count > 0) {
                                  fetchUsers(count);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Please enter a valid number')),
                                  );
                                }
                              },
                              child: Text('Refresh'),
                            ),
                            ElevatedButton(
                              onPressed: saveAsPDF,
                              child: Text('Download PDF'),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ],
        ),
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
