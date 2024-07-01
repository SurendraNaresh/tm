import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'newlogs.dart';
//import 'show_calc.dart';
import 'show_dragdrop.dart';
import 'LoggerWidget.dart';

//Logger log = Logger('testLogApp', 'mylog.csv');
void main() => runApp(LoggerWidget(
    logger: Logger('flpro1_log','fpro1Applog.csv'),
    child: HelloWorldPage()
  ),
);

class HelloWorldPage extends StatelessWidget {
  HelloWorldPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
	  debugShowCheckedModeBanner : false,
      	
      title: 'Navigation pop/push-PageRoute',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
//  const HomePage({Key? key, required this.title}) : super(key: key);
  const HomePage({Key? key}) : super(key: key);

  // const MyHomePage({super.key, required this.title});
  // Fields in a Widget subclass are always marked "final".
  // final String title;
  // final LoggerWidget logger	= logger('flpro1App','flpro.csv');

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
        title: Text("AppBar: FL_pro1:Route-Page Demos"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('This is the HelloWorld page...', style:TextStyle(color: Colors.deepOrange,fontSize:35) ),
            ElevatedButton(
              child: Text('Start Demo_page: Drag And Drop'),
              onPressed: (){  
            	//Navigator.pop(context);  //
            	Navigator.push(
            		context,
            			//MaterialPageRoute(builder: (context)=>ShowWidgetPage()),	
            			MaterialPageRoute(builder: (context)=>DragAndDropPage()),	
            	);	
            },
            ),
          ],
        ),
      ),
    );
  }
}
