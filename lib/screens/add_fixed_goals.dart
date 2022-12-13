import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasks/constants/shared_prefrences.dart';
import 'package:tasks/screens/home_page.dart';

import '../constants/constant.dart';
import '../constants/curd.dart';

class NewFixedGoal extends StatefulWidget {
  const NewFixedGoal({Key? key}) : super(key: key);

  @override
  State<NewFixedGoal> createState() => _NewFixedGoalState();
}

class _NewFixedGoalState extends State<NewFixedGoal> {
  var nameController = TextEditingController();
  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: KSecondaryColor,
        title: const Text(
          'إضافة هدف ثابت جديد',
          style: TextStyle(color: KTextLightColor, fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(KDefaultPadding),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'اسم الهدف',
                icon: Icon(Icons.title, color: KPrimaryColor),
              ),
              cursorColor: KPrimaryColor,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                onPressed: () {
                  setState(
                    () {
                      CURD.curd.creteNewFixedTable(nameController.text).then(
                        (value) {
                          fixedMissionNames.add(nameController.text);
                          SharedPref.setStringListData(
                            key: fixedMissionNamesKey,
                            value: fixedMissionNames,
                          );
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyHomePage(),
                            ),
                            (route) => false,
                          );
                        },
                      );
                    },
                  );
                },
                color: KPrimaryColor,
                shape:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                child: const Text(
                  'إضافة الهدف',
                  style: TextStyle(color: KBackgroundColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
