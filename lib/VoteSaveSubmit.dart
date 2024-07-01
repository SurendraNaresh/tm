import 'package:flutter/material.dart';
import 'datacrud.dart';
import 'dart:async';

class VoteAndSaveNavigation extends StatelessWidget {
  final VoidCallback onSubmitCallback;
  final VoidCallback onSaveCallback;

  VoteAndSaveNavigation ({
    required this.onSubmitCallback,
    required this.onSaveCallback,
  }) {
		null ;	
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ElevatedButton(
          onPressed: () async {
            //await saveData(); // Save data to simulated file
            onSubmitCallback(); // Execute onSubmitCallback
          },
          child: Text('Submit and Go-Back', style: TextStyle(color: Colors.green)),
        ),
        Spacer(),
        ElevatedButton(
          onPressed: () {    
            onSaveCallback(); // Execute onSaveCallback
            //Navigator.pop(context); // Navigate back after saving
          },
          child: Text('Save Data', style: TextStyle(color: Colors.lightBlue)),
        ),
      ],
    );
  }

  Future<void> saveData() async {
    // Simulated save data to a file
    print('Data saved to file...[message]');
  }
}
