import 'package:easy_table/easy_table.dart';
import 'package:flutter/material.dart';

import '../../constants/constant.dart';
import '../../constants/curd.dart';
import '../../constants/note.dart';
import '../note_page.dart';

class ComplexGoalRatingScreen extends StatefulWidget {
  ComplexGoalRatingScreen({Key? key}) : super(key: key);

  @override
  State<ComplexGoalRatingScreen> createState() =>
      _ComplexGoalRatingScreenState();
}

class _ComplexGoalRatingScreenState extends State<ComplexGoalRatingScreen> {
  List<EasyTableModel<NoteModel>> models = [];

  List<List<NoteModel>> complexNotes = [];

  Future<void> getAllNotes() async {
    // List<List<NoteModel>> complexNotes = [];
    for (var element in complexMissionNames) {
      await CURD.curd.query(element).then((value) async {
        setState(() {
          complexNotes.add(value);
        });
      });
    }
    for (var element in complexNotes) {
      models.add(
        EasyTableModel<NoteModel>(
          rows: element,
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
              stringValue: (row) =>
                  '${row.noteDay != 'none' ? row.noteDay : ''}  ${row.noteTime.toString()}',
              weight: 2,
            ),
          ],
        ),
      );
      // return complexNotes;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllNotes();
  }

  @override
  void dispose() {
    models = [];
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // log(complexNote.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'تقييم الأهداف المجمعة',
        ),
      ),
      body: complexNotes.isNotEmpty
          ? ListView.separated(
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: Text(
                        complexNotes[index][0].tableName!,
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
                    SizedBox(
                      height: 300,
                      child: EasyTable(
                        models[index],
                        columnsFit: true,
                        focusable: true,
                        onRowTap: (NoteModel note) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotePage(
                                note: note,
                                table: note.tableName.toString(),
                              ),
                            ),
                          );
                        },
                        // s
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                height: 20.0,
              ),
              itemCount: complexNotes.length,
            )
          : const Center(
              child: Text('لا يوجد أهداف ثابتة'),
            ),
    );
  }
}
