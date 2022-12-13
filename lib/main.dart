import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tasks/constants/shared_prefrences.dart';
import 'package:tasks/screens/splash_screen.dart';

import 'constants/constant.dart';
import 'constants/curd.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPref.init();
  await CURD.curd.init();
  complexMissionNames =
      await SharedPref.getStringListData(key: complexMissionNamesKey) ?? [];
  fixedMissionNames =
      await SharedPref.getStringListData(key: fixedMissionNamesKey) ?? [];

  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    null,
    [
      NotificationChannel(
        channelGroupKey: 'scheduled_notification_channel_group',
        channelKey: channelKey,
        channelName: 'Scheduled Notification',
        channelDescription: 'Scheduled Notification for Alarm',
        defaultColor: const Color(0xfffc2904),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        soundSource: 'resource://raw/alarm',
        locked: true,
        defaultRingtoneType: DefaultRingtoneType.Alarm,
        // enableLights: true,
        // playSound: true,
        // enableVibration: true,
      ),
    ],
    // Channel groups are only visual and are not required
    channelGroups: [
      NotificationChannelGroup(
        channelGroupkey: 'scheduled_notification_channel_group',
        channelGroupName: 'Scheduled Notification group',
      )
    ],
    debug: true,
  );
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // This is just a basic example. For real apps, you must show some
      // friendly dialog box before call the request method.
      // This is very important to not harm the user experience
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'مهمات هشام',
      theme: ThemeData(
        textTheme: GoogleFonts.almaraiTextTheme(Theme.of(context).textTheme),
        primaryColor: KPrimaryColor,
        primarySwatch: const MaterialColor(0xfffc2904, {
          50: Color(0x1afc2904),
          100: Color(0x33fc2904),
          200: Color(0x4dfc2904),
          300: Color(0x66fc2904),
          400: Color(0x80fc2904),
          500: Color(0x99fc2904),
          600: Color(0xb3fc2904),
          700: Color(0xccfc2904),
          800: Color(0xe6fc2904),
          900: Color(0xfffc2904),
        }),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('ar', 'EG'),
      supportedLocales: const [
        Locale('ar', 'EG'),
      ],
      home: const SplashScreen(),
    );
  }
}
