import 'dart:async';
import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:flutter/material.dart';
import 'package:tasks/constants/constant.dart';
import 'package:tasks/screens/home_page.dart';
import 'package:tasks/screens/notification_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    _timer = Timer(const Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => MyHomePage()), (route) => false);
    });
    AwesomeNotifications().actionStream.listen((receivedAction) {
      _timer!.cancel();
      var payload = receivedAction.payload;
      log('Action Stream: $payload');
      log(receivedAction.id.toString());
      if (receivedAction.channelKey == channelKey) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (_) => NotificationPage(
                    id: int.parse(payload!['id'].toString()),
                    table: payload['table'].toString(),
                  )),
          (route) => route.isFirst,
        );
      } else {
        AwesomeNotifications().actionSink.close();
        AwesomeNotifications().createdSink.close();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MyHomePage()),
          (route) => false,
        );
      }
    }).onError((error) {
      log(error.toString());
      AwesomeNotifications().actionSink.close();
      AwesomeNotifications().createdSink.close();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MyHomePage()),
        (route) => false,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(
                height: 20,
              ),
              Text('جاري التحميل...'),
            ],
          ),
        ),
      ),
    );
  }
}
