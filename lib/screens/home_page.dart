import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:tasks/add_items_and_goals/add_total_goal.dart';
import 'package:tasks/constants/note.dart';
import 'package:tasks/constants/curd.dart';
import 'package:tasks/screens/fixed_goals.dart';
import 'package:tasks/add_items_and_goals/new_goal.dart';
import 'package:tasks/screens/info_screen.dart';
import 'package:tasks/screens/notification_page.dart';
import 'package:tasks/screens/search_screen.dart';

import 'archive_screen.dart';
import '../add_items_and_goals/elements.dart';
import '../constants/constant.dart';
import 'note_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool value = false;
  List<NoteModel> singleNotes = [];
  List<List<NoteModel>> complexNote = [];

  @override
  void initState() {
    print(complexMissionNames);
    CURD.curd.query(tableName).then((value) {
      setState(() {
        singleNotes = value;
      });
    });
    for (var element in complexMissionNames) {
      CURD.curd.query(element).then((value) {
        setState(() {
          complexNote.add(value);
        });
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.topRight,
        padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'images/background1.jpg',
                ),
                fit: BoxFit.fitHeight,
                filterQuality: FilterQuality.high)),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const InfoScreen(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.info_outline,
                            )),
                      ),
                      const Expanded(
                        child: CircleAvatar(
                          backgroundImage: AssetImage('images/user.jpg'),
                          radius: KDefaultPadding * 1.5,
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SearchScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.search)),
                      ),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    Center(
                      child: SizedBox(
                        height: 150,
                        width: 150,
                        child: CircularProgressIndicator(
                          value: calculateNotes() != 0
                              ? calculateDone().toDouble() /
                                  calculateNotes().toDouble()
                              : 0.0,
                          backgroundColor: Colors.grey,
                          strokeWidth: 8,
                          color: KPrimaryColor,
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 50,
                        ),
                        child: Text(
                          '${calculateDone()} / ${calculateNotes()}',
                          style: const TextStyle(
                            fontSize: 40,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50, top: 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: KTextLightColor,
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: KDefaultPadding * 1.5,
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const FixedGoals(),
                                    ));
                              },
                              icon: const Icon(
                                Icons.task,
                                color: KTextLightColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: KDefaultPadding * 1.5,
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ArchivePage(),
                                    ));
                              },
                              icon: const Icon(
                                Icons.archive,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text('الأهداف المجمعة',
                    style: Theme.of(context).textTheme.headline5),
                const SizedBox(
                  height: 20,
                ),
                if (complexNote.isEmpty) const Text('لا يوجد أهداف مجمعة'),
                if (complexNote.isNotEmpty)
                  GridView.builder(
                    primary: false,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: complexNote.length,
                    itemBuilder: (context, index) {
                      log(index.toString());
                      return complexItem(
                        complexMissionNames[index],
                        complexNote[index],
                      );
                    },
                  ),
                const SizedBox(
                  height: 20,
                ),
                Text('الأهداف الفردية',
                    style: Theme.of(context).textTheme.headline5),
                const SizedBox(
                  height: 20,
                ),
                if (singleNotes.isEmpty) const Text('لا يوجد أهداف فردية'),
                if (singleNotes.isNotEmpty)
                  GridView(
                    primary: false,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: singleNotes.map((e) => singleItem(e)).toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('إضافة عنصر'),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NewGoal(
                                  table: tableName,
                                ),
                              ),
                            );
                          },
                          color: KPrimaryColor,
                          padding: const EdgeInsets.all(10),
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          child: const Text('فردي'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const NewTotalGoal(),
                                ));
                          },
                          color: KPrimaryColor,
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          child: const Text('مجمع'),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        },
        backgroundColor: KPrimaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget complexItem(String? itemName, List<NoteModel> note) =>
      SingleChildScrollView(
        child: Column(
          children: [
            ClipOval(
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ElementsPage(
                          tableName: itemName!,
                          isFixed: false,
                        ),
                      ));
                },
                child: const CircleAvatar(
                  radius: KDefaultPadding * 2,
                  backgroundImage: AssetImage(
                    'images/golden.jpg',
                  ),
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  width: 180,
                  child: ExpansionTile(
                    title: Text(
                      itemName!,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: KPrimaryColor),
                      textAlign: TextAlign.center,
                    ),
                    children: note.map((item) {
                      return CheckboxListTile(
                        activeColor: KPrimaryColor,
                        value: item.status == noteStatusComplete ? true : false,
                        onChanged: (value) {
                          if (item.status == noteStatusComplete) {
                            setState(() {
                              item.status = noteStatusNotComplete;
                            });
                          } else {
                            setState(() {
                              item.status = noteStatusComplete;
                            });
                          }
                          log(item.status.toString());
                          CURD.curd.update(item, itemName);
                        },
                        title: Text(item.name.toString()),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  width: 120,
                  height: 15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(150),
                  ),
                  child: LinearPercentIndicator(
                    width: 120,
                    lineHeight: 15,
                    percent: 0,
                    center: Text(
                      note.length.toString(),
                    ),
                    backgroundColor: Colors.grey,
                    progressColor: KPrimaryColor,
                  ),
                ),
              ],
            )
          ],
        ),
      );

  Widget singleItem(NoteModel note) => Column(
        children: [
          ClipOval(
            child: MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotePage(
                      note: note,
                      table: tableName,
                    ),
                  ),
                );
              },
              child: const CircleAvatar(
                radius: KDefaultPadding * 2,
                backgroundImage: AssetImage(
                  'images/golden.jpg',
                ),
              ),
            ),
          ),
          Text(
            note.name!,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: KPrimaryColor,
            ),
          ),
          CheckboxListTile(
            activeColor: KPrimaryColor,
            value: note.status == noteStatusComplete ? true : false,
            onChanged: (value) {
              if (note.status == noteStatusComplete) {
                setState(() {
                  note.status = noteStatusNotComplete;
                });
              } else {
                setState(() {
                  note.status = noteStatusComplete;
                });
              }
              log(note.status.toString());
              CURD.curd.update(note, tableName);
            },
            title: const Text('تم'),
          )
        ],
      );

  int calculateDone() {
    int done = 0;
    for (var element in complexNote) {
      for (var note in element) {
        if (note.status == noteStatusComplete) {
          done++;
        }
      }
    }
    for (var item in singleNotes) {
      if (item.status == noteStatusComplete) {
        done++;
      }
    }
    return done;
  }

  int calculateNotes() {
    int total = 0;
    for (var element in complexNote) {
      total += element.length;
    }
    total += singleNotes.length;
    return total;
  }
}
