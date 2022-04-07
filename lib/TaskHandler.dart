// The callback function should always be a top-level function.
import 'dart:isolate';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:http/http.dart' as http;

class FirstTaskHandler extends TaskHandler {
  int updateCount = 0;
  void Function() updateCallback;

  FirstTaskHandler({required this.updateCallback});

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    print("FirstTaskHandler onStart");
    // You can use the getData function to get the data you saved.
    final customData =
        await FlutterForegroundTask.getData<String>(key: 'customData');
    print('customData: $customData');
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    print("FirstTaskHandler onEvent");
    FlutterForegroundTask.updateService(
        notificationTitle: 'FirstTaskHandler',
        notificationText: timestamp.toString(),
        callback: updateCount >= 10 ? updateCallback : null);

    var url = Uri.parse('https://google.com');
    var response = await http.get(url);
    print("response : ${response.body}");

    // Send data to the main isolate.
    sendPort?.send(timestamp);
    sendPort?.send(updateCount);

    updateCount++;
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    print("FirstTaskHandler onDestroy");
    // You can use the clearAllData function to clear all the stored data.
    await FlutterForegroundTask.clearAllData();
  }

  @override
  void onButtonPressed(String id) {
    print("FirstTaskHandler onButtonPressed");
    // Called when the notification button on the Android platform is pressed.
    print('onButtonPressed >> $id');
  }
}

class SecondTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    print("SecondTaskHandler onStart");
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    print("SecondTaskHandler onEvent");
    FlutterForegroundTask.updateService(
        notificationTitle: 'SecondTaskHandler',
        notificationText: timestamp.toString());

    // Send data to the main isolate.
    sendPort?.send(timestamp);
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    print("SecondTaskHandler onDestroy");
  }
}
