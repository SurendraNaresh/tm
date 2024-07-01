import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class FileChooserPage extends StatefulWidget {
  @override
  _FileChooserPageState createState() => _FileChooserPageState();
}

class _FileChooserPageState extends State<FileChooserPage> {
  String? _filePath;
  String? _fileContent;
  int _totalLines = 0;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt', 'dart', 'yaml'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String content = await file.readAsString();
      setState(() {
        _filePath = result.files.single.path;
        _fileContent = content;
        _totalLines = content.split('\n').length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Chooser'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _pickFile,
            child: Text('Pick a file'),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: _fileContent != null
                  ? Text(_fileContent!)
                  : Text('No file selected.'),
            ),
          ),
        ],
      ),
      floatingActionButton: _fileContent != null
          ? FloatingActionButton.extended(
              onPressed: () {},
              label: Text('Total lines: $_totalLines'),
              icon: Icon(Icons.info),
            )
          : null,
    );
  }
}

void main() => runApp( FileChooserPage() );
