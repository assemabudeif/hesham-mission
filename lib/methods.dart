import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'constants/constant.dart';
import 'constants/note.dart';
import 'dart:developer';

void addNewNotification(NoteModel note, int id, String table) async {
  var dates = note.noteDate!.split('/');
  var time = note.noteTime!.split(':');

  // current time
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: note.notificationId!,
      payload: {'id': id.toString(), 'table': table},
      channelKey: channelKey,
      title: note.name,
      category: NotificationCategory.Alarm,
      body: 'اضغط هنا لمشاهدة الهدف',
      wakeUpScreen: true,
      notificationLayout: NotificationLayout.Default,
      showWhen: true,
    ),
    schedule: NotificationCalendar(
      repeats: false,
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

  // 15 minute before
  await subtract15MinutesIntoNotification(time).then((timeBefore) async {
    log('Time Before: $timeBefore');
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: note.notificationId! - 15,
        payload: {'id': id.toString(), 'table': table},
        channelKey: channelKey,
        title: note.name,
        category: NotificationCategory.Alarm,
        body: 'وقت هذا الهدف بعد 15 دقيقة',
        wakeUpScreen: true,
        notificationLayout: NotificationLayout.Default,
        showWhen: true,
      ),
      schedule: NotificationCalendar(
        repeats: false,
        day: int.parse(dates[0]),
        month: int.parse(dates[1]),
        year: int.parse(dates[2]),
        hour: int.parse(timeBefore[0]),
        minute: int.parse(timeBefore[1]),
        millisecond: 0,
        second: 0,
        preciseAlarm: true,
        allowWhileIdle: true,
        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
      ),
    );
  }).catchError((error) {
    log(error.toString());
  });

  // 15 minute after
  await add15MinutesIntoNotification(time).then((timeAfter) async {
    log('Time After: $timeAfter');
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: note.notificationId! + 15,
        payload: {'id': id.toString(), 'table': table},
        channelKey: channelKey,
        title: note.name,
        category: NotificationCategory.Alarm,
        body: 'هل تم تنفيذ هذا الهدف ؟',
        wakeUpScreen: true,
        notificationLayout: NotificationLayout.Default,
        showWhen: true,
      ),
      schedule: NotificationCalendar(
        repeats: false,
        day: int.parse(dates[0]),
        month: int.parse(dates[1]),
        year: int.parse(dates[2]),
        hour: int.parse(timeAfter[0]),
        minute: int.parse(timeAfter[1]),
        second: 0,
        millisecond: 0,
        preciseAlarm: true,
        allowWhileIdle: true,
        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
      ),
    );
  }).catchError((error) {
    log(error.toString());
  });
}

Future<List<String>> add15MinutesIntoNotification(time) async {
  var hour = int.parse(time[0]);
  var minute = int.parse(time[1]);
  var newMinute = minute + 15;
  if (newMinute > 59) {
    hour = hour + 1;
    newMinute = newMinute - 60;
  }
  return [hour.toString(), newMinute.toString()];
}

Future<List<String>> subtract15MinutesIntoNotification(time) async {
  var hour = int.parse(time[0]);
  var minute = int.parse(time[1]);
  var newMinute = minute - 15;
  if (newMinute < 0) {
    hour = hour - 1;
    newMinute = newMinute + 60;
  }
  return [hour.toString(), newMinute.toString()];
}

void deleteNotification(int id) async {
  await AwesomeNotifications().cancel(id);
  await AwesomeNotifications().cancel(id + 15);
  await AwesomeNotifications().cancel(id - 15);
}

// var nameController = TextEditingController();
// var dateController = TextEditingController();
// var timeController = TextEditingController();
// bool isRecording = false;
// final record = Record();
// String audioPath = '';
// List<NoteModel> notes = [];
// final player = AudioPlayer();
// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
// NoteModel? singleNote;

// Future<void> getDatabaseInstance() async {
//   await CURD.curd.init();
// }

// Future<void> startRecord() async {
//   // Check and request permission
//   if (await record.hasPermission()) {
//     // Start recording
//     await record.start(
//       encoder: AudioEncoder.aacLc, // by default
//       bitRate: 128000, // by default
//       samplingRate: 44100, // by default
//     );
//   }
// // Get the state of the recorder
//   isRecording = await record.isRecording();
// }

// Future<void> stopRecording() async {
//   await record.stop().then((value) {
//     audioPath = value!;
//     print(value);
//   });
//   isRecording = await record.isRecording();
// }

// Future<void> getAllNotes(String table) async {
//   notes = [];
//   await CURD.curd.query(table).then((value) {
//     notes = value;
//     print(notes);
//   }).catchError((error) {
//     print(error.toString());
//   });
// }

// Future<void> createNewTable(String table) async {
//   await CURD.curd.creteNewTable(table).then((value) {}).catchError((error) {
//     print(error.toString());
//   });
// }

// Future<void> addNewNote(NoteModel note, String table) async {
//   await CURD.curd.insert(note, table).then((value) {
//     nameController.clear();
//     dateController.clear();
//     timeController.clear();
//     audioPath = '';
//     addNewNotification(note, value, table);
//     getAllNotes(table);
//   }).catchError((error) {
//     print(error.toString());
//   });
// }

// Future<void> deleteNote(NoteModel note, String table) async {
//   await CURD.curd.delete(note.id!.toInt(), table).then((value) {
//     deleteAudio(note.voicePath.toString());
//     getAllNotes(table);
//   }).catchError((error) {
//     print(error.toString());
//   });
// }

// Future<void> updateNote(NoteModel note, String table) async {
//   await CURD.curd.update(note, table).then((value) {
//     getAllNotes(table);
//   }).catchError((error) {
//     print(error.toString());
//   });
// }

// void showCustomDatePicker(BuildContext context) {
//   showDatePicker(
//     context: context,
//     initialDate: DateTime.now(),
//     firstDate: DateTime.now(),
//     lastDate: DateTime.now().add(const Duration(days: 365)),
//   ).then((value) {
//     dateController.text = DateTimeManager.dateFormat(value!);
//
//     print(dateController.text);
//   }).catchError((error) {
//     print(error.toString());
//   });
// }

// void showCustomTimePicker(BuildContext context) {
//   showTimePicker(
//     context: context,
//     initialTime: TimeOfDay.now(),
//   ).then((value) {
//     timeController.text = DateTimeManager.timeFormat(value!);
//     print(timeController.text);
//   }).catchError((error) {
//     print(error.toString());
//   });
// }

// void playAudio(String path) async {
//   player.setFilePath(path);
//   player.setVolume(1.0);
//   player.play();
// }

// void pauseAudio() async {
//   player.pause();
// }

// void stopAudio() async {
//   player.stop();
// }

// Future<void> deleteAudio(String path) async {
//   try {
//     await File(path).delete();
//     getAllNotes(tableName);
//   } on FileSystemException catch (e) {
//     print(e.message);
//   }
// }

// Future<NoteModel> getSingleNote() async {
//   // emit(GetNoteLoadingState());
//   return await CURD.curd.getNote(tableName, 1);
//   //     .then((value) {
//   //   singleNote = value;
//   //   emit(GetNoteSuccessState());
//   // }).catchError((error) {
//   //   print(error.toString());
//   //   emit(GetNoteErrorState());
//   // });
// }

// Future<void> setNotePage(BuildContext context) async {
//   if (noteId != null) {
//     singleNote = await getSingleNote();
//     // Navigator.pushNamed(context, RoutesManager.singleNote);
//     noteId = null;
//     // await getSingleNote().then((value) async {
//     //   singleNote = value;
//     //   Navigator.pushNamed(context, RoutesManager.singleNote);
//     //   noteId = null;
//     // });
//   }
// }
