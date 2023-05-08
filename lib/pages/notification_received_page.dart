import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotificationReceivedPage extends StatelessWidget {
  const NotificationReceivedPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text(
          'Notification',
        ),
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop()
        ),
      ),
      body: Center(
        child: Text(
          'Notification Tapped',
        ),
      ),
    );
  }
}
