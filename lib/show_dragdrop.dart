import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'newlogs.dart';
import 'LoggerWidget.dart';

//void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo: Drag and drop',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.teal,
      ),
      // home: const MyHomePage(title: 'Flutter Drag & Drop Page'),
	  home: DragAndDropPage(),
    );
  }
}

class DragAndDropPage extends StatefulWidget {
//  final Logger logger = Logger.getInstance(); // Get the singleton instance
  @override
  _DragAndDropPageState createState() => _DragAndDropPageState();
}

class _DragAndDropPageState extends State<DragAndDropPage> {
  String? _draggedItem;
  late Logger? vlog; // Declare logger outside initState
  //final String? title;
  int clogctr = 0;	
  @override
  void initState() {
    super.initState();
  } 
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
  
  @override
  Widget build(BuildContext context) {
    //BuildContext ctx = super.context;
    vlog = LoggerWidget.of(context); // Access context here
    vlog?.addData('module_import', 'version_001'); // Use pre-fetched logger
	vlog?.stop();
    vlog?.writeLog();


    return Scaffold(
      appBar: AppBar(
        title: Text('LoggerWidget with DragDrop'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           //Text('This is the New widget page...'),
            ElevatedButton(
              child: Text('Press to go back'),
              onPressed: () {
				var dcode = (clogctr % 3 == 0) ? 'No' : ((clogctr % 2 == 0) ? 'Yes' : 'Abs');
                String contextData=jsonEncode({'User_name': 'UserDrag${clogctr}',
                                    	'campaign_desc': 'Desc:CampDescbyDrag${clogctr}',
                                    	'vote': '${dcode}', 
                                    	'remark': "User_Voted:${dcode}",
                                    	});
                    //print(json.dump(contextData);
					print('Entering logdetails for: User${clogctr}');
					vlog?.addData('Camp_User${clogctr}',contextData);     	
				              
				if (Navigator.of(context).canPop()) {
					vlog?.stop();
					vlog?.writeLog();
					Navigator.pop(context);
				}
              },
            ),
            Draggable<String>(
              data: 'Flutter',
              child: Container(
                width: 100.0,
                height: 100.0,
                color: Colors.blue,
                child: Center(
                  child: Text('Drag Me'),
                ),
              ),
              feedback: Container(
                width: 100.0,
                height: 100.0,
                color: Colors.blue.withOpacity(0.5),
                child: Center(
                  child: Text('Text-for-Block'),
                ),
              ),
              childWhenDragging: Container(
                width: 100.0,
                height: 100.0,
                color: Colors.grey,
                child: Center(
                  child: Text('Dragged'),
                ),
              ),
              onDragStarted: () {
                setState(() {
                  _draggedItem = '{Code-Block}';
                });
              },
            ),
            SizedBox(height: 20.0),
            DragTarget<String>(
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: 200.0,
                  height: 200.0,
                  color: Colors.grey,
                  child: Center(
                    child: Text(
                      _draggedItem != null ? 'Drop $_draggedItem here' : 'Drop Here',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
              onWillAccept: (data) {
                return true;
              },
              onAccept: (data) {
                setState(() {
				   clogctr = clogctr + 1;
                  _draggedItem = null;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(const MyApp());

