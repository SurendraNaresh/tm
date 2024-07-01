import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

const String _defaultAppName = "MyApp"; // Static app name
const String _defaultLogFilename = "app.log"; // Static log file name

class Logger {
  final String appName;
  final String logFile;
  DateTime? startTime;
  DateTime? endTime;
  Duration? totalTime;
  double? upTime;
  final Map<String, dynamic> otherData = {};
  
  Logger._internal({required this.appName, required this.logFile});
  Logger(this.appName, this.logFile) {
    startTime = DateTime.now();
  }
  factory Logger.getInstance() {
    return Logger._internal(appName: _defaultAppName, logFile: _defaultLogFilename);
  }


  void addData(String key, dynamic value) {
    otherData[key] = value;
  }
  double? get reCalcTime {
	stop();
	return upTime;
  }
  void stop() {
    endTime = DateTime.now();
    totalTime = endTime!.difference(startTime!);
    upTime = totalTime!.inSeconds.toDouble();
  }

  String formatTimeOnly(DateTime dateTime) {
    String formattedTime = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
    if (dateTime.difference(DateTime.now()).inDays != 0) {
      formattedTime = '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} $formattedTime';
    }
    return formattedTime;
  }

  Future<void> writeLog() async {
    final appDir = './ddir';  // await getApplicationDocumentsDirectory();
    final logPath =  '$appDir/$logFile';
	//print('The logfilePath : ${logPath}');
	// avoid Log-Creation Issues :>> by calling stop() method 
	(upTime ?? -99 ) < -1 ? stop() : 0; 

	if (upTime != null) {
		List<dynamic> data = [
			  appName,
			  startTime!,
			  formatTimeOnly(endTime!),
			  "",
			  totalTime,
			  upTime,
			  otherData,
			];
			List<String> dataStrings = data.map((value) => value.toString()).toList();
			await File(logPath).writeAsString(dataStrings.join(","), mode: FileMode.append);
	}	
	else {
		print('Check Log-Creation Issues in $logPath'); 
	}
  }
}

void main() async {
  Logger logger = Logger('testLogApp', 'mylog.csv');
  logger.addData('version', '1.0');
  logger.stop();
  await logger.writeLog();
  print('Log written successfully.');
  
}
