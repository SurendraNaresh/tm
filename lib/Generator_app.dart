import 'package:flutter/material.dart';
import 'dart:io';

class AppGenerator extends StatefulWidget {
  @override
  _AppGeneratorState createState() => _AppGeneratorState();
}

class _AppGeneratorState extends State<AppGenerator> {
  // Declare TextEditingControllers for user input
  final TextEditingController appNameController = TextEditingController();
  final TextEditingController fileNameController = TextEditingController();
  final TextEditingController tableNameController = TextEditingController();

  // Function to handle processing button press
  void handleProcessButtonPressed() {
    // Get user inputs
    String appName = appNameController.text;
    String fileName = fileNameController.text;
    String tableName = tableNameController.text;

    // Check if file exists
    File file = File(fileName);
    if (!file.existsSync()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('File does not exist!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Run Shell Script
    Process.run('bash', ['your_script.sh', fileName, tableName, appName])
        .then((ProcessResult results) {
      if (results.exitCode == 0) {
        // Parse output and update UI
        // For example, you can display the modified file content
        print('Script executed successfully');
      } else {
        // Display error message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Error executing script: ${results.stderr}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Generator'),
      ),
      body: Column(
        children: [
          // Row for user input fields
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: appNameController,
                  decoration: InputDecoration(labelText: 'App Name'),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: fileNameController,
                  decoration: InputDecoration(labelText: 'File Name'),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: tableNameController,
                  decoration: InputDecoration(labelText: 'Database Table'),
                ),
              ),
            ],
          ),
          // Expanded column for results and button
          Expanded(
            child: Column(
              children: [
                // Display parsed file content (implementation omitted)
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: handleProcessButtonPressed,
                  child: Text('Process'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
