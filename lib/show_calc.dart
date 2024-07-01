//import 'dart:svg';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(myWidgetPage());

class myWidgetPage extends StatelessWidget {
  myWidgetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Navigating using push-MaterialPageRoute',
      home: ShowWidgetPage(),
    );
  }
}

class ShowWidgetPage extends myWidgetPage {
  final String title = 'Hello World';
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('This is the New widget page...'),
            ElevatedButton(
              child: Text('Press to go back'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
          		children: [
            		Icon(Icons.forward, size: 33),
            		Text('ThirdItem', style: TextStyle(color: Colors.red, fontSize: 33)),
          		],),
           	  Column(
              children: [
            		Icon(Icons.file_download, size: 33),
            		Text('FourthItem', style: TextStyle(color: Colors.yellow, fontSize: 33)),
          		],),
              Column(
          		children: [
            		Icon(Icons.bluetooth, size: 33),
            		Text('+5+', style: TextStyle(color: Colors.deepPurple, fontSize: 33)),
          		],
          	  ),
           ],
         ),
        ],
      ),
     ),
    );
  }
}

