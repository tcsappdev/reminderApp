import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:reminder_app/pages/home_page.dart';
import 'package:reminder_app/pages/notification_received_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        playSound: true,
        criticalAlerts: true,)
    ],
    debug: true
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Named Routes Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        "/notification_received_page": (context) => NotificationReceivedPage(),
      },
    );
  }
}
