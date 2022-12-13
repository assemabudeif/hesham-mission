import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';
import 'package:tasks/add_items_and_goals/elements.dart';
import 'package:tasks/constants/constant.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:tasks/constants/curd.dart';
import 'package:tasks/constants/date_time_manager.dart';
import 'package:tasks/constants/note.dart';
import 'package:tasks/screens/home_page.dart';
import '../constants/note.dart';
import '../methods.dart';

class NewItemPage extends StatefulWidget {
  NewItemPage({Key? key, required this.table, required this.isFixed})
      : super(key: key);
  final String table;
  bool isFixed = false;

  @override
  State<NewItemPage> createState() => _NewItemPageState();
}

class _NewItemPageState extends State<NewItemPage> {
  final formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  bool isRecording = false;
  final record = Record();
  String audioPath = '';
  final player = AudioPlayer();
  bool isPlaying = false;

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
      lastDate: DateTime.now().add(const Duration(days: 365)),
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
    var dates = note.noteDate!.split('/');
    var time = note.noteTime!.split(':');
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
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
        day: int.parse(dates[0]),
        month: int.parse(dates[1]),
        year: int.parse(dates[2]),
        hour: int.parse(time[0]),
        minute: int.parse(time[1]),
        preciseAlarm: true,
        allowWhileIdle: true,
        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
      ),
    );
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
      body: SafeArea(
        child: Padding(
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
                  TextFormField(
                    controller: dateController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'الرجاء إدخال تاريخ الهدف';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'تاريخ الهدف',
                      icon: Icon(Icons.date_range, color: KPrimaryColor),
                    ),
                    readOnly: true,
                    autofocus: false,
                    onTap: () => showCustomDatePicker(context),
                  ),
                  const SizedBox(height: 20),
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
                        if (formKey.currentState!.validate() &&
                            audioPath != '') {
                          NoteModel note = NoteModel(
                            notificationId: DateTime.now()
                                .millisecondsSinceEpoch
                                .remainder(100000),
                            name: nameController.text,
                            noteDate: dateController.text,
                            noteTime: timeController.text,
                            voicePath: audioPath,
                            status: noteStatusNotComplete,
                            type: noteTypeSingle,
                            tableName: widget.table,
                          );
                          CURD.curd.insert(note, widget.table).then((value) {
                            if (widget.isFixed) {
                              addNewFixedNotification(note, value);
                            } else {
                              addNewNotification(note, value, widget.table);
                            }
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
      ),
    );
  }
}
