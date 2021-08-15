import 'dart:io';

import 'package:mytodo/model/notes.dart';
import 'package:mytodo/model/task.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NoteDatabaseHelper {
  static Database _db;
  static const String TABLE = 'reminder';
  static const String DB_NAME = 'reminder.db';
  static const String ID = 'id';
  static const String TITLE = 'title';
  static const String CONTENT = 'content';
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
        $CONTENT TEXT,
         )''');
  }

  static Future<Note> saveNote(Note note) async {
    var dbClient = await db;
    note.id = await dbClient.insert(TABLE, note.toMap());
    return note;
  }

  static Future<List<Note>> getNotes() async {
    var dbClient = await db;
    List<Map> map = await dbClient.query(
      TABLE,
      columns: [
        ID,
        TITLE,
        CONTENT,
        DATECREATED,
      ],
    );
    List<Note> reminderList = [];
    if (map != null) {
      for (var i = 0; i < map.length; i++) {
        reminderList.add(Note.fromMap(map[i]));
      }
    }
    reminderList.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));

    return reminderList;
  }

  static Future<int> deleteNote(int id) async {
    var dbClient = await db;
    return dbClient.delete(
      TABLE,
      where: '$ID = ?',
      whereArgs: [id],
    );
  }

  static Future<int> deleteAllNote() async {
    var dbClient = await db;
    return dbClient.delete(TABLE);
  }

  static Future<int> updateNote(Note note) async {
    var dbClient = await db;
    return dbClient.update(
      TABLE,
      note.toMap(),
      where: '$ID = ?',
      whereArgs: [note.id],
    );
  }
}
