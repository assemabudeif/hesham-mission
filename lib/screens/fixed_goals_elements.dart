import 'package:flutter/material.dart';
import 'package:tasks/add_items_and_goals/add_single_items.dart';
import 'package:tasks/add_items_and_goals/new_goal.dart';
import 'package:tasks/constants/constant.dart';
import 'package:tasks/constants/note.dart';
import 'package:tasks/constants/shared_prefrences.dart';
import 'package:tasks/methods.dart';
import 'package:tasks/screens/add_fixed_goal_item.dart';
import 'package:tasks/screens/home_page.dart';
import 'package:tasks/screens/note_page.dart';
import '../constants/constant_goal.dart';
import '../constants/curd.dart';

class FixedGoalsElementsPage extends StatefulWidget {
  FixedGoalsElementsPage(
      {Key? key, required this.tableName, required this.isFixed})
      : super(key: key);
  final String tableName;
  bool isFixed = false;

  @override
  State<FixedGoalsElementsPage> createState() => _FixedGoalsElementsPageState();
}

class _FixedGoalsElementsPageState extends State<FixedGoalsElementsPage> {
  List<NoteModel> notes = [];
  bool isLoading = true;

  @override
  void initState() {
    // CURD.curd.query(widget.tableName).then(
    //   (value) {
    //     setState(() {
    //       notes = value;
    //       print(notes);
    //       isLoading = false;
    //     });
    //   },
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'العناصر',
          style: TextStyle(color: KPrimaryColor),
        ),
        backgroundColor: KSecondaryColor,
        actions: [
          IconButton(
              onPressed: () {
                fixedMissionNames.remove(widget.tableName);
                SharedPref.setStringListData(
                    key: fixedMissionNamesKey, value: fixedMissionNames);

                CURD.curd.dropTable(widget.tableName).then(
                  (value) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const MyHomePage()),
                      (route) => false,
                    );
                  },
                );
              },
              icon: const Icon(Icons.delete)),
        ],
      ),
      body: FutureBuilder(
        future: CURD.curd.query(widget.tableName),
        builder:
            (BuildContext context, AsyncSnapshot<List<NoteModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              padding: const EdgeInsets.all(12),
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return defaultMissionItem(
                  inArchive: true,
                  note: snapshot.data![index],
                  table: widget.tableName,
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 16,
                );
              },
              itemCount: snapshot.data!.length,
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.hashCode.toString()),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddFixedGoalItemPage(
                table: widget.tableName,
              ),
            ),
          );
        },
        backgroundColor: KSecondaryColor,
        child: const Icon(
          Icons.add,
          color: KTextLightColor,
        ),
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
                      if (note.noteDay != '')
                        Text(
                          'يوم: ${note.noteDay} - الساعة : ${note.noteTime}',
                          style: const TextStyle(
                            color: KBackgroundColor,
                            fontSize: 16,
                          ),
                        ),
                      if (note.noteDay == '')
                        Text(
                          ' الساعة : ${note.noteTime}',
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
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          note.tableName = archiveTableName;
                          CURD.curd.update(note, table).then((value) {
                            CURD.curd
                                .insert(note, archiveTableName)
                                .then((value) {
                              CURD.curd
                                  .delete(note.id!.toInt(), table)
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
                        icon: const Icon(
                          Icons.archive,
                          color: Colors.white,
                        ),
                        tooltip: 'حفظ في الأرشيف',
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            CURD.curd
                                .delete(note.id!.toInt(), table)
                                .then((value) {
                              deleteNotification(note.notificationId!);
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const MyHomePage()),
                                (route) => false,
                              );
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
                ],
              ),
            ),
          ),
        ),
      );
}
