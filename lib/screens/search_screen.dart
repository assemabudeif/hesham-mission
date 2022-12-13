import 'package:flutter/material.dart';
import 'package:tasks/constants/curd.dart';
import 'package:tasks/constants/note.dart';
import 'package:tasks/methods.dart';
import 'package:tasks/screens/note_page.dart';

import '../constants/constant.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var searchController = TextEditingController();
  List<List<NoteModel>> allNotes = [];
  List<List<NoteModel>> searchNotes = [];

  Future<void> _getSingleNotes() async {
    CURD.curd.query(tableName).then(
      (value) {
        setState(() {
          allNotes.add(value);
        });
      },
    );
  }

  Future<void> _getComplexNotes() async {
    for (var element in complexMissionNames) {
      CURD.curd.query(element).then(
        (value) {
          setState(() {
            allNotes.add(value);
          });
        },
      );
    }
  }

  Future<void> _getFixedNotes() async {
    for (var element in fixedMissionNames) {
      CURD.curd.query(element).then(
        (value) {
          setState(() {
            allNotes.add(value);
          });
        },
      );
    }
  }

  Future<void> _getArchiveNotes() async {
    CURD.curd.query(archiveTableName).then(
      (value) {
        setState(() {
          allNotes.add(value);
        });
      },
    );
  }

  Future<void> getAllTables() async {
    allNotes = [];
    _getSingleNotes();
    _getArchiveNotes();
    _getComplexNotes();
    _getFixedNotes();
  }

  Future<void> search(String text) async {
    searchNotes = [];
    for (var element in allNotes) {
      for (var note in element) {
        if (note.name!.contains(text)) {
          setState(() {
            searchNotes.add([note]);
          });
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getAllTables();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'البحث',
          style: TextStyle(color: KPrimaryColor),
        ),
        backgroundColor: KSecondaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: KPrimaryColor,
                ),
                labelText: 'بحث',
                labelStyle: const TextStyle(fontWeight: FontWeight.w100),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onChanged: (value) {
                search(value);
              },
              cursorColor: KPrimaryColor,
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: searchNotes.isNotEmpty
                  ? ListView.builder(
                      itemCount: searchNotes.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: defaultMissionItem(
                            table: searchNotes[index][0].tableName!,
                            note: searchNotes[index][0],
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text('لا يوجد نتائج'),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget defaultMissionItem({
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
                  KPrimaryColor,
                  KSecondaryColor,
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
                ],
              ),
            ),
          ),
        ),
      );
}
