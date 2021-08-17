import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mytodo/database/note_db.dart';
import 'package:mytodo/model/notes.dart';



class NoteProvider extends ChangeNotifier {
  List<Note> notes = [];

  Future<List<Note>> getNotes() async {
    Future<List<Note>> list = NoteDatabaseHelper.getNotes();
    await list.then((notes) {
      this.notes = notes;
      notifyListeners();
    });
    return list;
  }

  void createNote(Note note) async {
    if (note.title.isEmpty && note.content.isEmpty) return;
    await NoteDatabaseHelper.saveNote(note);
  }

  TextStyle getTextStyle(BuildContext context, Note note,
     [ double fontSize, FontWeight fontWeight]) {
    if (Theme.of(context).brightness == Brightness.dark)
      return TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight);
    else
      return TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight);
  }

  updateNotes(Note note) async {
    await NoteDatabaseHelper.updateNote(note);
    getNotes();
    notifyListeners();
  }

  void deleteNote(int id) {
    NoteDatabaseHelper.deleteNote(id);
    getNotes();
    notifyListeners();
  }
 
}
