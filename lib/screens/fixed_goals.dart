import 'dart:developer';

import 'package:easy_table/easy_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tasks/screens/add_fixed_goals.dart';
import 'package:tasks/screens/fixed_goals_elements.dart';
import 'package:tasks/screens/fixed_goals_rating_screen.dart';

import '../add_items_and_goals/elements.dart';
import '../constants/constant.dart';
import '../constants/curd.dart';
import '../constants/note.dart';

class FixedGoals extends StatefulWidget {
  const FixedGoals({Key? key}) : super(key: key);

  @override
  State<FixedGoals> createState() => _FixedGoalsState();
}

class _FixedGoalsState extends State<FixedGoals> {
  List<List<NoteModel>> fixedNotes = [];

  Future<void> getAllTables() async {
    for (var element in fixedMissionNames) {
      CURD.curd.query(element).then(
        (value) {
          setState(() {
            fixedNotes.add(value);
          });
        },
      );
    }
  }

  @override
  void initState() {
    log(fixedMissionNames.toString());
    getAllTables();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الأهداف الثابتة',
          style: TextStyle(color: KPrimaryColor),
        ),
        backgroundColor: KSecondaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NewFixedGoal()));
        },
        backgroundColor: KPrimaryColor,
        child: const Icon(Icons.add),
      ),
      body: fixedNotes.isNotEmpty
          ? Column(
              children: [
                MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FixedGoalsRatingScreen(
                            notes: fixedNotes,
                          ),
                        ),
                      );
                    },
                    color: KPrimaryColor,
                    child: const Text(
                      'اضغط هنا لعرض الجداول',
                      style: TextStyle(color: Colors.white),
                    )),
                Padding(
                  padding: const EdgeInsets.all(KDefaultPadding * 1.5),
                  child: Stack(
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
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(KDefaultPadding),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: fixedNotes.length,
                    itemBuilder: (context, index) {
                      log(index.toString());
                      return complexItem(
                        fixedMissionNames[index],
                        fixedNotes[index],
                      );
                    },
                  ),
                ),
              ],
            )
          : const Center(
              child: Text(
                'لا يوجد أهداف ثابتة',
                style: TextStyle(
                  color: KPrimaryColor,
                  fontSize: 20,
                ),
              ),
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
                        builder: (context) => FixedGoalsElementsPage(
                          tableName: itemName!,
                          isFixed: true,
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

  int calculateDone() {
    int done = 0;
    for (var element in fixedNotes) {
      for (var note in element) {
        if (note.status == noteStatusComplete) {
          done++;
        }
      }
    }

    return done;
  }

  int calculateNotes() {
    int total = 0;
    for (var element in fixedNotes) {
      total += element.length;
    }
    return total;
  }
}
