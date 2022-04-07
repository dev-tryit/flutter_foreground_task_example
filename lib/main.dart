import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_foreground_task_example/TaskHandler.dart';
import 'package:flutter_foreground_task_example/page/FlutterForegroundTaskPage.dart';
import 'package:flutter_foreground_task_example/util/ForegroundTaskUtil.dart';

void main() => runApp(const MyApp());


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyForegroundTaskUtil.buildTaskWidget(
        child: FlutterForegroundTaskPage(),
      ),
    );
  }


}
