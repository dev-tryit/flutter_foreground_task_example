import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_foreground_task_example/TaskHandler.dart';
import 'package:flutter_foreground_task_example/util/ForegroundTaskUtil.dart';

class FlutterForegroundTaskPage extends StatefulWidget {
  const FlutterForegroundTaskPage({Key? key}) : super(key: key);

  @override
  State<FlutterForegroundTaskPage> createState() =>
      _FlutterForegroundTaskPageState();
}

class _FlutterForegroundTaskPageState extends State<FlutterForegroundTaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Foreground Task'),
        centerTitle: true,
      ),
      body: _buildContentView(),
    );
  }

  Widget _buildContentView() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTestButton('start',
            onPressed: () => MyForegroundTaskUtil.startForegroundTask()),
        _buildTestButton('stop',
            onPressed: () => MyForegroundTaskUtil.stopForegroundTask()),
      ],
    ));
  }

  Widget _buildTestButton(String text, {VoidCallback? onPressed}) {
    return ElevatedButton(
      child: Text(text),
      onPressed: onPressed,
    );
  }
}
