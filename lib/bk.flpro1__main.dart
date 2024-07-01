import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'show_calc.dart';

void main() => runApp(HelloWorldPage());

class HelloWorldPage extends StatelessWidget {
  HelloWorldPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
	  debugShowCheckedModeBanner : false,
      	
      title: 'Navigating using push-MaterialPageRoute',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
//  const HomePage({Key? key, required this.title}) : super(key: key);
  const HomePage({Key? key}) : super(key: key);
  //const MyHomePage({super.key, required this.title});
  // Fields in a Widget subclass are always marked "final".
  //final String title;

  @override
  State<HomePage> createState() => ShowHomePage();
}

class ShowHomePage extends State<HomePage> {
  //final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text("AppBar: FL_pro1: Demo applications"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('This is the HelloWorld page...', style:TextStyle(color: Colors.deepPurple,fontSize:35) ),
            ElevatedButton(
              child: Text('Press to go back'),
              onPressed: (){  
            	//Navigator.pop(context);  //
            	Navigator.push(
            		context,
            			MaterialPageRoute(builder: (context)=>ShowWidgetPage()),	
            	);	
            },
            ),
          ],
        ),
      ),
    );
  }
}
