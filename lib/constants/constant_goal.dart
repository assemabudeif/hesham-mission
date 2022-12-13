import 'package:flutter/material.dart';
import 'package:tasks/constants/constant.dart';
import 'package:tasks/constants/curd.dart';
import 'package:tasks/constants/note.dart';

class AppConstants {
  static Widget defaultMissionItem({
    bool inArchive = false,
    NoteModel? note,
  }) =>
      GestureDetector(
        onTap: () {},
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          // color: ColorManager.primaryLight,
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
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.archive,
                          color: Colors.white,
                        ),
                        tooltip: 'حفظ في الأرشيف',
                      ),
                      IconButton(
                        onPressed: () {},
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
