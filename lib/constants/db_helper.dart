import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'constant.dart';

class DbHelper {
  DbHelper._instance();
  static final DbHelper helper = DbHelper._instance();

  //get the path where the db created
  Future<String> getDbPath() async {
    String dbPath = await getDatabasesPath();
    return join(dbPath, dbName);
  }

  //create single object from db
  Future<Database> getDbInstance() async {
    String path = await getDbPath();
    print(path);
    return openDatabase(
      path,
      // singleInstance: true,
      version: dbVersion,
      onCreate: (db, dbVersion) => _onCreateDb(db),
    );
  }

  //create table inside your db
  _onCreateDb(Database db) {
    String sql =
        'create table $tableName ($colId integer primary key autoincrement, $colNotificationId integer, $colName text, $colDate text, $colDay text, $colTime text, $colVoicePath text, $colStatus text, $colType text, $colTableName text)';
    db.execute(sql).then((value) {
      print('$tableName Success created');
    }).catchError((error) {
      log(error.toString());
    });
    String sql1 =
        'create table $archiveTableName ($colId integer primary key autoincrement, $colNotificationId integer, $colName text, $colDate text, $colDay text, $colTime text, $colVoicePath text, $colStatus text, $colType text, $colTableName text)';
    db.execute(sql1).then((value) {
      print('$archiveTableName Success created');
    }).catchError((error) {
      log(error.toString());
    });
  }
}
