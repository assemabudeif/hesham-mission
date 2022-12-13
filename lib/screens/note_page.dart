import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tasks/constants/constant.dart';
import 'package:tasks/constants/note.dart';
import 'package:tasks/methods.dart';
import 'package:tasks/screens/home_page.dart';

import '../constants/curd.dart';
import '../constants/note.dart';
import 'edit_note_page.dart';

class NotePage extends StatefulWidget {
  const NotePage({Key? key, required this.note, required this.table})
      : super(key: key);
  final NoteModel note;
  final String table;

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note.name!),
        backgroundColor: KPrimaryColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('تاريخ الهدف: ${widget.note.noteDate}',
                style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Text('وقت الهدف: ${widget.note.noteTime}',
                style: Theme.of(context).textTheme.headlineSmall),
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
                    isPlaying ? stopAudio() : playAudio(widget.note.voicePath!);
                  },
                  backgroundColor: KPrimaryColor,
                  child: Icon(
                    isPlaying ? Icons.stop : Icons.audiotrack,
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Align(
              alignment: Alignment.center,
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditNotePage(
                        note: widget.note,
                        table: widget.table,
                      ),
                    ),
                  );
                },
                color: KPrimaryColor,
                child: const Text(
                  'تعديل الهدف',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Align(
              alignment: Alignment.center,
              child: MaterialButton(
                onPressed: () {
                  widget.note.tableName = archiveTableName;
                  CURD.curd.update(widget.note, widget.table).then((value) {
                    CURD.curd
                        .insert(widget.note, archiveTableName)
                        .then((value) {
                      deleteNote(widget.note, widget.table).then((value) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyHomePage(),
                          ),
                          (route) => false,
                        );
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
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Align(
              alignment: Alignment.center,
              child: MaterialButton(
                onPressed: () {
                  deleteNote(widget.note, widget.table);
                },
                color: KPrimaryColor,
                child: const Text(
                  'حذف الهدف',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
