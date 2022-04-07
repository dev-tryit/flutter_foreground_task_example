import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_foreground_task_example/TaskHandler.dart';

//이 함수는 반드시 최상위에 있어야 한다.
void useStartHandler() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(
      FirstTaskHandler(updateCallback: useUpdateHandler));
}

//이 함수는 반드시 최상위에 있어야 한다.
void useUpdateHandler() {
  FlutterForegroundTask.setTaskHandler(SecondTaskHandler());
}

class MyForegroundTaskUtil {
  static ReceivePort? _receivePort;

  static MyTaskWidget buildTaskWidget({required Widget child}) {
    return MyTaskWidget(child: child, receivePort: _receivePort);
  }

  static Future<bool> startForegroundTask() async {
    // You can save data using the saveData function.
    await FlutterForegroundTask.saveData(key: 'customData', value: 'hello');

    ReceivePort? receivePort;
    if (await FlutterForegroundTask.isRunningService) {
      receivePort = await FlutterForegroundTask.restartService();
    } else {
      receivePort = await FlutterForegroundTask.startService(
          notificationTitle: 'Foreground Service is running',
          notificationText: 'Tap to return to the app',
          callback: useStartHandler);
    }

    if (receivePort != null) {
      _receivePort = receivePort;
      _receivePort?.listen(onMessage);

      return true;
    }

    return false;
  }

  static Future<bool> stopForegroundTask() async {
    return await FlutterForegroundTask.stopService();
  }

  static void onMessage(message) {
    if (message is DateTime) {
      print('receive timestamp: $message');
    } else if (message is int) {
      print('receive updateCount: $message');
    }
  }
}

class MyTaskWidget extends StatefulWidget {
  final Widget child;
  final ReceivePort? receivePort;

  const MyTaskWidget({Key? key, required this.child, required this.receivePort})
      : super(key: key);

  @override
  State<MyTaskWidget> createState() => _MyTaskWidgetState();
}

class _MyTaskWidgetState extends State<MyTaskWidget> {
  Future<void> _initForegroundTask() async {
    await FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'notification_channel_id',
        channelName: 'Foreground Notification',
        channelDescription:
            'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
        ),
        buttons: [
          const NotificationButton(id: 'sendButton', text: 'Send'),
          const NotificationButton(id: 'testButton', text: 'Test'),
        ],
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 5000,
        autoRunOnBoot: true,
        allowWifiLock: true,
      ),
      printDevLog: true,
    );
  }

  @override
  void initState() {
    super.initState();
    _initForegroundTask();
  }

  @override
  void dispose() {
    widget.receivePort?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // A widget that prevents the app from closing when the foreground service is running.
    // This widget must be declared above the [Scaffold] widget.
    return WithForegroundTask(child: widget.child);
  }
}
