import 'package:easy_table/easy_table.dart';
import 'package:flutter/material.dart';
import 'package:tasks/constants/constant.dart';
import 'package:tasks/constants/note.dart';
import 'package:tasks/methods.dart';

class FixedGoalsRatingScreen extends StatefulWidget {
  final List<List<NoteModel>> notes;
  const FixedGoalsRatingScreen({Key? key, required this.notes})
      : super(key: key);

  @override
  _FixedGoalsRatingScreenState createState() => _FixedGoalsRatingScreenState();
}

class _FixedGoalsRatingScreenState extends State<FixedGoalsRatingScreen> {
  // EasyTableModel<List<NoteModel>>? _model;
  List<EasyTableModel<NoteModel>> _models = [];
  @override
  void initState() {
    // TODO: implement initState
    for (var element in widget.notes) {
      _models.add(
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
          ],
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'تقييم الأهداف الثابتة',
          style: TextStyle(color: KPrimaryColor),
        ),
        backgroundColor: KSecondaryColor,
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: Text(
                  fixedMissionNames[index],
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: KPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                ),
              ),
              SizedBox(
                height: 300,
                child: EasyTable(
                  _models[index],
                  // s
                ),
              ),
            ],
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
          height: 20.0,
        ),
        itemCount: widget.notes.length,
      ),
    );
  }
}
