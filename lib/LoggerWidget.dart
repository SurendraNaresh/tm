//import 'newlogs.dart';
import 'sharedlog.dart';
import 'package:flutter/widgets.dart';
class LoggerWidget extends InheritedWidget {
  final Logger logger;
  LoggerWidget({
    required this.logger,
    required Widget child,
  }) : super(child: child);

  static Logger? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LoggerWidget>()?.logger;
  }
  bool updateShouldNotify(LoggerWidget old){
	return (old.logger != logger);
  }
}
