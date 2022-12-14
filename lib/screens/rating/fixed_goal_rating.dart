import 'package:easy_table/easy_table.dart';
import 'package:flutter/material.dart';

import '../../constants/constant.dart';
import '../../constants/curd.dart';
import '../../constants/note.dart';
import '../note_page.dart';

class FixedGoalRatingScreen extends StatefulWidget {
  const FixedGoalRatingScreen({Key? key}) : super(key: key);

  @override
  State<FixedGoalRatingScreen> createState() => _FixedGoalRatingScreenState();
}

class _FixedGoalRatingScreenState extends State<FixedGoalRatingScreen> {
  // EasyTableModel<List<NoteModel>>? _model;
  List<EasyTableModel<NoteModel>> models = [];
  List<List<NoteModel>> fixedNotes = [];
  Future<List<List<NoteModel>>> getAllNotes() async {
    for (var element in fixedMissionNames) {
      fixedNotes = [];
      CURD.curd.query(element).then((value) async {
        fixedNotes.add(value);
      });
    }
    return fixedNotes;
  }

  @override
  void initState() {
    // TODO: implement initState
    models = [];
    fixedNotes = [];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // log(complexNote.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'تقييم الأهداف الثابتة',
        ),
      ),
      body: FutureBuilder(
        future: getAllNotes(),
        builder: (context, AsyncSnapshot<List<List<NoteModel>>> snapshot) {
          snapshot.data?.forEach((element) {
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
          });
          return fixedNotes.isNotEmpty
              ? ListView.separated(
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: Text(
                            fixedNotes[index][0].tableName!,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
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
                  itemCount: snapshot.data!.length,
                )
              : const Center(
                  child: Text('لا يوجد أهداف ثابتة'),
                );
        },
      ),
    );
  }
}
