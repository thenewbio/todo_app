import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mytodo/database/note_db.dart';
import 'package:mytodo/model/notes.dart';

class NoteProvider extends ChangeNotifier {
  delete(Note note) {
    DatabaseHelper.instance.deleteNote(note.id);
  }

  aboutUs(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("About US"),
              content: ListView(children: [
                Text(
                    "Welcome to Todo plus, your number one source for all things involving organizing your daily tasks.\n We're dedicated to providing you the very best of task management.Founded in 2021 by Innocent, Todo plus has come a long way from its beginnings in Nigeria.When Innocent first started out, his passion for creating a friendly task management app drove them to start their own business.We hope you enjoy our products as much as we enjoy offering them to you. If you have any questions or comments, please don't hesitate to contact us.\nThanks"),
              ]),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("OK"))
              ],
            ));
  }
}
