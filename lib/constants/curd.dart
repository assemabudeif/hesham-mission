import 'package:sqflite/sqflite.dart';

import 'constant.dart';
import 'db_helper.dart';
import 'note.dart';

class CURD {
  CURD._instance();
  static final CURD curd = CURD._instance();
  Database? _db;
  init() async {
    _db = await DbHelper.helper.getDbInstance();
  }

  Future<List<NoteModel>> query(String table) async {
    List<Map<String, dynamic>> mapData =
        await _db!.query(table, orderBy: '$colDate DESC');
    print(mapData);
    return mapData.map((e) => NoteModel.fromJson(e)).toList();
  }

  Future<NoteModel> getNote(String table, int id) async {
    List<Map<String, dynamic>> mapData =
        await _db!.rawQuery('SELECT * FROM $table WHERE $colId = $id');
    _db!.rawQuery('SELECT * FROM $table WHERE $colId = $id').then((value) {
      print(value);

      for (var element in value) {
        print(element);
      }
    });
    // await _db!.query(table, where: '$colId = ?', whereArgs: [id]);

    print(mapData);
    return NoteModel.fromJson(mapData[0]);
    // return mapData.map((e) => NoteModel.fromJson(e)).toList().first;
  }

  Future<void> dropTable(String table) async {
    await _db!.execute('DROP TABLE $table');
  }

  Future<void> creteNewTable(String table) async {
    String sql =
        'create table $table ($colId integer primary key autoincrement,  $colNotificationId int, $colName text, $colDate text, $colDay text, $colTime text, $colVoicePath text, $colStatus text, $colType text, $colTableName text)';
    return await _db!.execute(sql);
  }

  Future<void> creteNewFixedTable(String table) async {
    String sql =
        'create table $table ($colId integer primary key autoincrement,  $colNotificationId integer, $colName text, $colDate text, $colTime text, $colDay text, $colVoicePath text, $colStatus text, $colType text, $colTableName text)';
    return await _db!.execute(sql);
  }

  Future<int> insert(NoteModel note, String tableName) async {
    return _db!.insert(tableName, note.toJson());
  }

  Future<int> delete(int id, String table) async {
    return _db!.delete(table, where: '$colId = ?', whereArgs: [id]);
  }

  Future<int> update(NoteModel note, String table) async {
    return _db!.update(table, note.toJson(),
        where: '$colId = ?', whereArgs: [note.id]);
  }

  Future<int> done(int id, String table) async {
    return _db!.update(
        table,
        {
          colStatus: noteStatusComplete,
        },
        where: '$colId = ?',
        whereArgs: [id]);
  }

  Future<void> close() async {
    await _db!.close();
  }
}
