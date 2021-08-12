import 'dart:io';

import 'package:mytodo/model/task.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TaskDatabaseHelper {
  static Database _db;
  static const String TABLE = 'reminder';
  static const String DB_NAME = 'reminder.db';
  static const String ID = 'id';
  static const String TITLE = 'title';
  static const String CONTENT = 'content';
  static const String CATEGORY = 'category';
  static const String ISIMPORTANT = 'isImportant';
  static const String ISACTIVE = 'isActive';
  static const String SCHEDULEDDATE = 'scheduledDate';
  static const String SCHEDULEDTIME = 'scheduledTime';
  static const String DATECREATED = 'dateCreated';

  static Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initializeDatabase();
    return _db;
  }

  static initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, DB_NAME);
    return await openDatabase(path, version: 1, onCreate: createDatabase);
  }

  static createDatabase(Database db, int version) async {
    await db.execute(
        '''CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY AUTOINCREMENT, 
        $TITLE TEXT, $DATECREATED TEXT, 
        $CONTENT TEXT, $CATEGORY TEXT, $ISIMPORTANT BOOLEAN,
         $ISACTIVE BOOLEAN, $SCHEDULEDDATE TEXT, $SCHEDULEDTIME TEXT)''');
  }

  static Future<Task> saveReminder(Task reminder) async {
    var dbClient = await db;
    reminder.id = await dbClient.insert(TABLE, reminder.toMap());
    return reminder;
  }

  static Future<List<Task>> getReminder() async {
    var dbClient = await db;
    List<Map> map = await dbClient.query(
      TABLE,
      columns: [
        ID,
        TITLE,
        CONTENT,
        CATEGORY,
        DATECREATED,
        ISIMPORTANT,
        ISACTIVE,
        SCHEDULEDDATE,
        SCHEDULEDTIME
      ],
    );
    List<Task> reminderList = [];
    if (map != null) {
      for (var i = 0; i < map.length; i++) {
        reminderList.add(Task.fromMap(map[i]));
      }
    }
    reminderList.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));

    return reminderList;
  }

  static Future<int> deleteReminder(int id) async {
    var dbClient = await db;
    return dbClient.delete(
      TABLE,
      where: '$ID = ?',
      whereArgs: [id],
    );
  }

  static Future<int> deleteAllReminder() async {
    var dbClient = await db;
    return dbClient.delete(TABLE);
  }

  static Future<int> updateReminder(Task reminder) async {
    var dbClient = await db;
    return dbClient.update(
      TABLE,
      reminder.toMap(),
      where: '$ID = ?',
      whereArgs: [reminder.id],
    );
  }
}
