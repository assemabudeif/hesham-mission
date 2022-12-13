import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';
import 'package:tasks/constants/constant.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:tasks/constants/curd.dart';
import 'package:tasks/constants/date_time_manager.dart';
import 'package:tasks/constants/note.dart';
import 'package:tasks/methods.dart';
import 'package:tasks/screens/home_page.dart';
import '../constants/note.dart';

class AddFixedGoalItemPage extends StatefulWidget {
  const AddFixedGoalItemPage({Key? key, required this.table}) : super(key: key);
  final String table;

  @override
  State<AddFixedGoalItemPage> createState() => _AddFixedGoalItemPageState();
}

class _AddFixedGoalItemPageState extends State<AddFixedGoalItemPage> {
  final formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  bool isRecording = false;
  final record = Record();
  String audioPath = '';
  final player = AudioPlayer();
  bool isPlaying = false;
  final _dayValue = 'Day';
  final _weekValue = 'Week';
  final _day = 'يومي';
  final _week = 'اسبوعي';
  String? _selectedTypeValue = 'Day';
  final List<int> daysNumber = [1, 2, 3, 4, 5, 6, 7];
  final List<String> days = [
    'الاثنين',
    'الثلاثاء',
    'الاربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
    'الاحد',
  ];
  int _selectedDayValue = 1;

  Future<void> startRecord() async {
    // Check and request permission
    if (await record.hasPermission()) {
      // Start recording
      setState(() {
        record.start(
          encoder: AudioEncoder.aacLc, // by default
          bitRate: 128000, // by default
          samplingRate: 44100, // by default
        );
      });
    }
// Get the state of the recorder
    setState(() {
      isRecording = true;
    });
  }

  Future<void> stopRecording() async {
    record.stop().then((value) {
      setState(() {
        audioPath = value!;
      });
      print(value);
    });
    setState(() {
      isRecording = false;
    });
  }

  void playAudio(String path) async {
    player.setFilePath(path);
    player.setVolume(1.0);
    player.play();
    setState(() {
      isPlaying = player.playing;
    });
  }

  void stopAudio() async {
    player.stop();
    setState(() {
      isPlaying = player.playing;
    });
  }

  void showCustomDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    ).then((value) {
      dateController.text = DateTimeManager.dateFormat(value!);

      print(dateController.text);
    }).catchError((error) {
      print(error.toString());
    });
  }

  void showCustomTimePicker(BuildContext context) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      timeController.text = DateTimeManager.timeFormat(value!);
      print(timeController.text);
    }).catchError((error) {
      print(error.toString());
    });
  }

  void addNewFixedNotification(NoteModel note, int id) async {
    var time = note.noteTime!.split(':');
    var timeBefore = await subtract15MinutesIntoNotification(time);
    var timeAfter = await add15MinutesIntoNotification(time);
    log(note.noteDay!);
    if (_selectedTypeValue == _dayValue) {
      try {
        log(note.noteTime.toString());
        // Current time
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: note.notificationId!,
            payload: {'id': id.toString(), 'table': widget.table},
            channelKey: channelKey,
            title: note.name,
            category: NotificationCategory.Alarm,
            body: 'اضغط هنا لمشاهدة الهدف',
            wakeUpScreen: true,
            notificationLayout: NotificationLayout.Default,
            showWhen: true,
            // customSound: 'resource://raw/alarm',
          ),
          schedule: NotificationCalendar(
            repeats: true,
            hour: int.parse(time[0]),
            minute: int.parse(time[1]),
            second: 0,
            millisecond: 0,
            allowWhileIdle: true,
          ),
        );

        // 15 minutes before
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: note.notificationId! - 15,
            payload: {'id': id.toString(), 'table': widget.table},
            channelKey: channelKey,
            title: note.name,
            category: NotificationCategory.Alarm,
            body: 'وقت هذا الهدف بعد 15 دقيقة',
            wakeUpScreen: true,
            notificationLayout: NotificationLayout.Default,
            showWhen: true,
            // customSound: 'resource://raw/alarm',
          ),
          schedule: NotificationCalendar(
            repeats: true,
            hour: int.parse(timeBefore[0]),
            minute: int.parse(timeBefore[1]),
            second: 0,
            millisecond: 0,
            allowWhileIdle: true,
          ),
        );

        // 15 minutes after
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: note.notificationId! + 15,
            payload: {'id': id.toString(), 'table': widget.table},
            channelKey: channelKey,
            title: note.name,
            category: NotificationCategory.Alarm,
            body: 'هل تم تنفيذ هذا الهدف ؟',
            wakeUpScreen: true,
            notificationLayout: NotificationLayout.Default,
            showWhen: true,
            // customSound: 'resource://raw/alarm',
          ),
          schedule: NotificationCalendar(
            repeats: true,
            hour: int.parse(timeAfter[0]),
            minute: int.parse(timeAfter[1]),
            second: 0,
            millisecond: 0,
            allowWhileIdle: true,
          ),
        );
      } on AwesomeNotificationsException catch (e) {
        log(e.message);
      }
    } else if (_selectedTypeValue == _weekValue) {
      try {
        // Current time
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: note.notificationId!,
            payload: {'id': id.toString(), 'table': widget.table},
            channelKey: channelKey,
            title: note.name,
            category: NotificationCategory.Alarm,
            body: 'اضغط هنا لمشاهدة الهدف',
            wakeUpScreen: true,
            notificationLayout: NotificationLayout.Default,
            showWhen: true,
            // customSound: 'resource://raw/alarm',
          ),
          schedule: NotificationCalendar(
            repeats: true,
            weekday: _selectedDayValue,
            hour: int.parse(time[0]),
            minute: int.parse(time[1]),
            second: 0,
            millisecond: 0,
            allowWhileIdle: true,
          ),
        );

        // 15 minutes before
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: note.notificationId! - 15,
            payload: {'id': id.toString(), 'table': widget.table},
            channelKey: channelKey,
            title: note.name,
            category: NotificationCategory.Alarm,
            body: 'وقت هذا الهدف بعد 15 دقيقة',
            wakeUpScreen: true,
            notificationLayout: NotificationLayout.Default,
            showWhen: true,
            // customSound: 'resource://raw/alarm',
          ),
          schedule: NotificationCalendar(
            repeats: true,
            weekday: _selectedDayValue,
            hour: int.parse(timeBefore[0]),
            minute: int.parse(timeBefore[1]),
            second: 0,
            millisecond: 0,
            allowWhileIdle: true,
          ),
        );

        // 15 minutes after
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: note.notificationId! + 15,
            payload: {'id': id.toString(), 'table': widget.table},
            channelKey: channelKey,
            title: note.name,
            category: NotificationCategory.Alarm,
            body: 'هل تم تنفيذ هذا الهدف ؟',
            wakeUpScreen: true,
            notificationLayout: NotificationLayout.Default,
            showWhen: true,
            // customSound: 'resource://raw/alarm',
          ),
          schedule: NotificationCalendar(
            repeats: true,
            weekday: _selectedDayValue,
            hour: int.parse(timeAfter[0]),
            minute: int.parse(timeAfter[1]),
            second: 0,
            millisecond: 0,
            allowWhileIdle: true,
          ),
        );
      } on AwesomeNotificationsException catch (e) {
        log(e.message);
      }
    }
  }

  @override
  void initState() {
    // _selectedTypeValue = _day;
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    dateController.dispose();
    timeController.dispose();
    audioPath = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: KSecondaryColor,
        title: const Text(
          'إضافة عنصر جديد',
          style: TextStyle(color: KTextLightColor, fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(KDefaultPadding),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم الهدف',
                    icon: Icon(Icons.title, color: KPrimaryColor),
                  ),
                  cursorColor: KPrimaryColor,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'الرجاء إدخال اسم الهدف';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DropdownButton<String>(
                  items: [
                    DropdownMenuItem(
                      value: _dayValue,
                      child: Text(_day),
                    ),
                    DropdownMenuItem(
                      value: _weekValue,
                      child: Text(_week),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedTypeValue = value!;
                      log(_selectedTypeValue.toString());
                    });
                  },
                  value: _selectedTypeValue,
                ),
                TextFormField(
                  controller: timeController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'الرجاء إدخال وقت الهدف';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'وقت الهدف',
                    icon: Icon(Icons.timer, color: KPrimaryColor),
                    // enabled: false,
                  ),
                  readOnly: true,
                  autofocus: false,
                  onTap: () => showCustomTimePicker(context),
                ),
                const SizedBox(height: 20),
                if (_selectedTypeValue == _weekValue)
                  DropdownButton<int>(
                    items: [
                      for (int i = 0; i < 7; i++)
                        DropdownMenuItem(
                          value: daysNumber[i],
                          child: Text(days[i].toString()),
                        ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedDayValue = value!;
                      });
                    },
                    value: _selectedDayValue,
                  ),
                Row(
                  children: [
                    const Text(
                      'تسجيل صوتي للهدف',
                      style: TextStyle(
                        color: KTextLightColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    AvatarGlow(
                      endRadius: MediaQuery.of(context).size.width * 0.15,
                      glowColor: KPrimaryColor,
                      animate: isRecording,
                      showTwoGlows: true,
                      repeat: true,
                      child: FloatingActionButton(
                        onPressed: () {
                          isRecording ? stopRecording() : startRecord();
                        },
                        backgroundColor: KPrimaryColor,
                        child: Icon(
                          isRecording ? Icons.stop : Icons.mic,
                        ),
                      ),
                    ),
                  ],
                ),
                if (audioPath != '')
                  Row(
                    children: [
                      const Text(
                        "معاينة الصوت",
                        style: TextStyle(
                          color: KTextLightColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.18,
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          isPlaying ? stopAudio() : playAudio(audioPath);
                        },
                        backgroundColor: KPrimaryColor,
                        child: Icon(
                          isPlaying ? Icons.stop : Icons.audiotrack,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    onPressed: () {
                      if (formKey.currentState!.validate() && audioPath != '') {
                        NoteModel note = NoteModel(
                          name: nameController.text,
                          notificationId: DateTime.now()
                              .millisecondsSinceEpoch
                              .remainder(100000),
                          noteDate: dateController.text,
                          noteTime: timeController.text,
                          noteDay: _selectedTypeValue == _weekValue
                              ? days[_selectedDayValue - 1]
                              : '',
                          voicePath: audioPath,
                          status: noteStatusNotComplete,
                          type: noteTypeFixed,
                          tableName: widget.table,
                        );
                        CURD.curd.insert(note, widget.table).then((value) {
                          addNewFixedNotification(note, value);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const MyHomePage();
                              },
                            ),
                            (route) => false,
                          );
                        });
                      }
                    },
                    color: KPrimaryColor,
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: const Text(
                      'إضافة الهدف',
                      style: TextStyle(color: KBackgroundColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
