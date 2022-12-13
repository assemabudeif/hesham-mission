import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tasks/constants/constant.dart';
import 'package:tasks/methods.dart';

import '../constants/curd.dart';
import '../constants/note.dart';
import 'note_page.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({Key? key}) : super(key: key);

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الأرشيف',
          style: TextStyle(color: KPrimaryColor),
        ),
        backgroundColor: KSecondaryColor,
      ),
      body: FutureBuilder(
        future: CURD.curd.query(archiveTableName),
        builder:
            (BuildContext context, AsyncSnapshot<List<NoteModel>> snapshot) {
          if (snapshot.hasData) {
            log(snapshot.data.toString());
            return ListView.separated(
              padding: const EdgeInsets.all(12),
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return defaultMissionItem(
                  inArchive: true,
                  note: snapshot.data![index],
                  table: archiveTableName,
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 16,
                );
              },
              itemCount: snapshot.data!.length,
            );
          } else if (snapshot.data! == []) {
            return const Center(
              child: Text('لا يوجد مهام مؤرشفة'),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget defaultMissionItem({
    bool inArchive = false,
    NoteModel? note,
    required String table,
  }) =>
      GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return NotePage(
              note: note!,
              table: table,
            );
          }));
        },
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [
                  KSecondaryColor,
                  KPrimaryColor,
                  KPrimaryColor,
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note!.name.toString(),
                        style: const TextStyle(
                          color: KBackgroundColor,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'بتاريخ: ${note.noteTime} - ${note.noteDate}',
                        style: const TextStyle(
                          color: KBackgroundColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        CURD.curd.delete(note.id!.toInt(), table).then((value) {
                          deleteNotification(note.notificationId!);
                        });
                      });
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    tooltip: 'حذف',
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
