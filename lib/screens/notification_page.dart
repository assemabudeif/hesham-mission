import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tasks/constants/constant.dart';
import 'package:tasks/constants/curd.dart';
import 'package:tasks/methods.dart';
import 'package:tasks/screens/delay_page.dart';
import 'package:tasks/screens/home_page.dart';

import '../constants/note.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key, required this.table, required this.id})
      : super(key: key);
  final String table;
  final int id;

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final player = AudioPlayer();
  bool isPlaying = false;
  String noteName = '';
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

  Future<void> deleteAudio(String path) async {
    try {
      await File(path).delete();
    } on FileSystemException catch (e) {
      print(e.message);
    }
  }

  Future<void> deleteNote(NoteModel note, String table) async {
    await CURD.curd.delete(note.id!.toInt(), table).then((value) {
      deleteAudio(note.voicePath.toString());
      deleteNotification(note.notificationId!.toInt());
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
        (route) => false,
      );
    }).catchError((error) {
      print(error.toString());
    });
  }

  Future<void> doneNote(int id, String table) async {
    await CURD.curd.done(id, table);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage()),
                (route) => false);
          },
        ),
      ),
      body: FutureBuilder(
        future: CURD.curd.getNote(widget.table, widget.id),
        builder: (BuildContext context, AsyncSnapshot<NoteModel> snapshot) {
          noteName = snapshot.data!.name.toString();
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'الهدف:  ${snapshot.data!.name.toString()}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Text('تاريخ الهدف: ${snapshot.data!.noteDate}',
                      style: Theme.of(context).textTheme.headlineSmall),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Text(
                    'وقت الهدف: ${snapshot.data!.noteTime}',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textDirection: TextDirection.rtl,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Row(
                    children: [
                      Text('الهدف:',
                          style: Theme.of(context).textTheme.headlineSmall),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.18,
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          isPlaying
                              ? stopAudio()
                              : playAudio(snapshot.data!.voicePath!);
                        },
                        backgroundColor: KPrimaryColor,
                        child: Icon(
                          isPlaying ? Icons.stop : Icons.audiotrack,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  MaterialButton(
                    onPressed: () {
                      doneNote(widget.id, widget.table).then((value) {
                        setState(() {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const MyHomePage()),
                              (route) => false);
                        });
                      });
                    },
                    color: KPrimaryColor,
                    child: const Text(
                      'تمت المهمة',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  MaterialButton(
                    onPressed: () {
                      snapshot.data!.tableName = archiveTableName;
                      CURD.curd
                          .update(snapshot.data!, widget.table)
                          .then((value) {
                        CURD.curd
                            .insert(snapshot.data!, archiveTableName)
                            .then((value) {
                          CURD.curd
                              .delete(snapshot.data!.id!.toInt(), widget.table)
                              .then((value) {
                            setState(() {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const MyHomePage()),
                                  (route) => false);
                            });
                          });
                        });
                      });
                    },
                    color: KPrimaryColor,
                    child: const Text(
                      'أرشفة الهدف',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  MaterialButton(
                    onPressed: () {
                      deleteNote(snapshot.data!, widget.table);
                    },
                    color: KPrimaryColor,
                    child: const Text(
                      'حذف الهدف',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DelayPage(
                            note: snapshot.data!,
                            table: widget.table,
                          ),
                        ),
                        (route) => false,
                      );
                    },
                    color: KPrimaryColor,
                    child: const Text('تأجيل الهدف',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
