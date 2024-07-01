import 'package:flutter/material.dart';

void main() => runApp(HelloWorldPage());

class HelloWorldPage extends StatelessWidget {
  HelloWorldPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigating using push-MaterialPageRoute',
      home: ShowPage(),
    );
  }
}

class ShowPage extends StatelessWidget {
  final String title = 'Hello World';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('This is the HelloWorld page...'),
            ElevatedButton(
              child: Text('Press to go back'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
