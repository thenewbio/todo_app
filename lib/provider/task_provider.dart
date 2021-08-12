import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mytodo/database/task_db.dart';
import 'package:mytodo/model/task.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> reminders = [];
  bool isActive = true;

  Future<List<Task>> getReminders() async {
    Future<List<Task>> list = TaskDatabaseHelper.getReminder();
    await list.then((reminders) {
      this.reminders = reminders;
      notifyListeners();
    });
    return list;
  }

  void reminderStateChange(bool isActive) {
    notifyListeners();
  }

  void createReminder(Task reminder) async {
    if (reminder.title.isEmpty && reminder.content.isEmpty) return;
    await TaskDatabaseHelper.saveReminder(reminder);
  }

  TextStyle getTextStyle(BuildContext context, Task reminder,
     [ double fontSize, FontWeight fontWeight]) {
    if (Theme.of(context).brightness == Brightness.dark)
      return TextStyle(
          color: reminder.isActive ? Colors.white : Colors.grey,
          fontSize: fontSize,
          fontWeight: fontWeight);
    else
      return TextStyle(
          color: reminder.isActive ? Colors.black : Colors.grey,
          fontSize: fontSize,
          fontWeight: fontWeight);
  }

  updateReminder(Task reminder) async {
    await TaskDatabaseHelper.updateReminder(reminder);
    getReminders();
    notifyListeners();
  }

  void deleteReminder(int id) {
    TaskDatabaseHelper.deleteReminder(id);
    getReminders();
    notifyListeners();
  }
}