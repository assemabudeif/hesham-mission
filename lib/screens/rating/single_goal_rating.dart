import 'package:easy_table/easy_table.dart';
import 'package:flutter/material.dart';
import 'package:tasks/constants/curd.dart';
import 'package:tasks/screens/note_page.dart';

import '../../constants/constant.dart';
import '../../constants/note.dart';

class SingleGOalRatingScreen extends StatefulWidget {
  const SingleGOalRatingScreen({Key? key}) : super(key: key);

  @override
  State<SingleGOalRatingScreen> createState() => _SingleGOalRatingScreenState();
}

class _SingleGOalRatingScreenState extends State<SingleGOalRatingScreen> {
  EasyTableModel<NoteModel>? _models;
  List<NoteModel> singleNotes = [];

  @override
  void initState() {
    // TODO: implement initState
    CURD.curd.query(tableName).then((value) {
      setState(() {
        singleNotes = value;
      });
      _models = EasyTableModel<NoteModel>(
        rows: singleNotes,
        columns: [
          EasyTableColumn(
            name: 'المهمة',
            stringValue: (row) => row.name.toString(),
          ),
          EasyTableColumn(
            name: 'تم',
            stringValue: (row) => row.status.toString(),
          ),
          EasyTableColumn(
            name: 'التاريخ',
            stringValue: (row) => '${row.noteDate}  ${row.noteTime.toString()}',
            weight: 2,
          ),
        ],
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تقييم الأهداف الفردية'),
      ),
      body: singleNotes.isNotEmpty
          ? Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Text(
                    'الأهداف الفردية',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: KPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: EasyTable(
                    _models,
                    columnsFit: true,
                    focusable: true,
                    onRowTap: (NoteModel note) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NotePage(note: note, table: tableName),
                        ),
                      );
                    },
                    // s
                  ),
                ),
              ],
            )
          : const Center(
              child: Text('لا يوجد اهداف'),
            ),
    );
  }
}
