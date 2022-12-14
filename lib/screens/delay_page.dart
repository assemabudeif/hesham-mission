import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tasks/constants/constant.dart';
import 'package:tasks/constants/curd.dart';
import 'package:tasks/constants/date_time_manager.dart';
import 'package:tasks/constants/note.dart';
import 'package:tasks/methods.dart';
import 'package:tasks/screens/home_page.dart';

class DelayPage extends StatefulWidget {
  const DelayPage({Key? key, required this.note, required this.table})
      : super(key: key);
  final NoteModel note;
  final String table;

  @override
  State<DelayPage> createState() => _DelayPageState();
}

class _DelayPageState extends State<DelayPage> {
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  final player = AudioPlayer();
  bool isPlaying = false;

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
      widget.note.noteDate = dateController.text;
      widget.note.status = noteStatusNotComplete;

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
      widget.note.noteTime = timeController.text;
      widget.note.status = noteStatusNotComplete;

      print(timeController.text);
    }).catchError((error) {
      print(error.toString());
    });
  }

  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تأجيل'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
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
            MaterialButton(
              onPressed: () {
                CURD.curd.update(widget.note, widget.table).then((value) {
                  addNewNotification(
                    widget.note,
                    widget.note.id!,
                    widget.table,
                    widget.note.type!,
                  );
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const MyHomePage()),
                      (route) => false);
                });
              },
              color: KPrimaryColor,
              textColor: Colors.white,
              child: const Text('تأجيل الهدف'),
            ),
          ],
        ),
      ),
    );
  }
}
