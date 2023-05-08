import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';

import 'package:reminder_app/utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TimeOfDay _pickedTime;

  @override
  void initState() {
    super.initState();

    AwesomeNotifications().createdStream.listen((receivedNotification) {
      String createdSourceText = AwesomeAssertUtils.toSimpleEnumString(
          receivedNotification.createdSource);
      Fluttertoast.showToast(msg: '$createdSourceText notification created');
    });

    AwesomeNotifications().displayedStream.listen((receivedNotification) {
      String createdSourceText = AwesomeAssertUtils.toSimpleEnumString(
          receivedNotification.createdSource);
      Fluttertoast.showToast(msg: '$createdSourceText notification displayed');
    });

    AwesomeNotifications().actionStream.listen((receivedNotification) {
      Navigator.pushNamed(context, "/notification_received_page");
      // receivedNotification.buttonKeyPressed, considerWhiteSpaceAsEmpty: true) ? 'normal tap' : receivedNotification.buttonKeyPressed }'
      Fluttertoast.showToast(
          msg:
              "Msg: ${AwesomeAssertUtils.isNullOrEmptyOrInvalid(receivedNotification.buttonKeyPressed, String)}",
          backgroundColor: Colors.blue[200],
          textColor: Colors.black);
    });

    AwesomeNotifications().dismissedStream.listen((receivedNotification) {
      String dismissedSourceText = AwesomeAssertUtils.toSimpleEnumString(
          receivedNotification.dismissedLifeCycle);
      Fluttertoast.showToast(
          msg: 'Notification dismissed on $dismissedSourceText');
    });
  }

  Future<bool> pickScheduleDate(BuildContext context) async {
    TimeOfDay timeOfDay;

    timeOfDay = await showTimePicker(
      context: context,
      initialTime: _pickedTime ?? TimeOfDay.now(),
    );

    // if (timeOfDay != null && (_pickedTime != timeOfDay)) {
    //   setState(() {
    _pickedTime = timeOfDay;
    // });
    //   return true;
    // }
    return true;
  }

  scheduleSleepReminder(TimeOfDay _pickedTime) async {
    int _notificationId = 1;
    DateTime _dateTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, _pickedTime.hour, _pickedTime.minute);

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
      if (!isAllowed) {
        // Insert here your friendly dialog box before call the request method
        // This is very important to not harm the user experience
        if (!await AwesomeNotifications().requestPermissionToSendNotifications(
            channelKey: "basic_channel",
            permissions: [
              NotificationPermission.Sound,
              NotificationPermission.Alert
            ])) {
          print('Notifications are not authorized');
          return;
        }
      }

      while (_notificationId < 2) {
        if (await showNotificationWithActionButtons(
          _notificationId,
          _dateTime,
        )) {
          if (Permission.camera.isPermanentlyDenied != null) {
            await openAppSettings();
          }
          print(
              'Notification Scheduled for Day - $_notificationId - $_dateTime');
        } else {
          print('Notification $_notificationId could not be created');
          return;
        }
        _notificationId += 1;
        _dateTime = _dateTime.add(Duration(days: 1));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text(
          'Sleep reminder',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: size.height * 0.02,
          bottom: size.height * 0.02,
          left: size.width * 0.05,
          right: size.width * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: size.height * 0.02,
                bottom: size.height * 0.02,
                left: size.width * 0.05,
                right: size.width * 0.05,
              ),
              child: Container(
                child: Image.asset(
                  'assets/sleep.jpeg',
                  // width: MediaQuery.of(context).size.width * 0.6,
                  // height: MediaQuery.of(context).size.height * 0.23,
                ),
              ),
            ),
            Text(
              'Good sleep can improve concentration and productivity',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: size.height * 0.020,
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                top: size.height * 0.045,
                bottom: size.height * 0.02,
                left: size.width * 0.05,
                right: size.width * 0.05,
              ),
              child: Column(
                children: [
                  Text(
                    'To create sleep reminder, Click the below button & enter your sleeping time',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: size.height * 0.020,
                      color: Colors.grey,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (await pickScheduleDate(context)) {
                        await scheduleSleepReminder(_pickedTime);
                      }
                    },
                    child: Text(
                      'Create sleep reminder',
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                bottom: size.height * 0.02,
                left: size.width * 0.05,
                right: size.width * 0.05,
              ),
              child: TextButton(
                onPressed: () async {
                  listScheduledNotifications(context);
                },
                child: Text(
                  'List all active schedules',
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () async {
                  cancelAllSchedules();
                },
                child: Text(
                  'Cancel all active schedules',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
