import 'dart:async';
// import 'dart:html';

import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mytodo/model/task.dart';
import 'package:mytodo/provider/task_provider.dart';
import 'package:mytodo/service/notification.dart';
import 'package:mytodo/widget/custom.dart';
import 'package:mytodo/widget/task_form.dart';
import 'package:provider/provider.dart';

class NewReminderScreen extends StatefulWidget {
  final Task reminder;
  const NewReminderScreen({Key key, this.reminder}) : super(key: key);

  @override
  _NewReminderScreenState createState() => _NewReminderScreenState();
}

class _NewReminderScreenState extends State<NewReminderScreen> {
  var titleController = new TextEditingController();
  var contentController = new TextEditingController();
  var selectedDate = DateTime.now().toLocal();
  String selectedTime = '';
  List<String> categories = [
    'Personal',
    'Movies',
    'Work',
    'Sport',
    'Birthday',
    'Shopping',
    'Miscellaneous'
  ];
  List<Color> colors = [Colors.green, Colors.purple];
  Color selectedValue = Colors.green;
  bool showDateTimeContent = false;

  @override
  void initState() {
    init();
    super.initState();
  }

  init() {
    String value = selectedValue.toString().split('(0x')[1].split(')')[0];

    if (widget.reminder != null) {
      showDateTimeContent = true;
      selectedTime = widget.reminder.scheduledTime;
      contentController.text = widget.reminder.content;
      titleController.text = widget.reminder.title;
      selectedDate = widget.reminder.scheduledDate;
      value = getSelectedValue();
    }
  }

  Future<DateTime> pickScheduleDate(BuildContext context) async {
    TimeOfDay timeOfDay;
    DateTime newDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate,
        lastDate: DateTime(2050));
    if (newDate != null && newDate != selectedDate)
      setState(() => selectedDate = newDate);
    if (newDate != null) {
      timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (timeOfDay != null)
        setState(() {
          selectedTime = timeOfDay.format(context);
          showDateTimeContent = true;
        });
      if (timeOfDay != null) {
        return DateTime(newDate.year, newDate.month, newDate.day,
            timeOfDay.hour, timeOfDay.minute);
      }
    }
    return null;
  }

  String getTitle() =>
      widget.reminder == null ? 'Add Reminder' : 'Edit Reminder';
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
        builder: (context, notifier, child) => SafeArea(
                child: Scaffold(
              appBar: AppBar(
                leading: IconButton(icon: Icon(Icons.arrow_back_ios_new),
                onPressed:() => Navigator.of(context).pop()),
                centerTitle: true,
                title: Text(getTitle()),
              ),
              body: Entry.opacity(
                delay: Duration(milliseconds: 600),
                duration: Duration(milliseconds: 800),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          buildContainer(
                              height: 75,
                              child: TaskForm(
                                  controller: titleController,
                                  hintText: 'Task Title')),
                          buildContainer(
                              child: TaskForm(
                            controller: contentController,
                            hintText: 'Brief description',
                          )),
                          GestureDetector(
                            onTap: () async {
                              await getSelectedDateTime();
                            },
                            child: buildContainer(
                              height: 80,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.alarm),
                                  SizedBox(width: 8),
                                  Text(
                                    'Set Time',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          !showDateTimeContent
                              ? Container()
                              : Entry.opacity(
                                  delay: Duration(milliseconds: 600),
                                  duration: Duration(milliseconds: 800),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: buildContainer(
                                              child: buildDateTimeCards(
                                                  text: 'Date',
                                                  time: DateFormat(
                                                          'dd MMM, yyyy')
                                                      .format(selectedDate)))),
                                      Expanded(
                                          child: buildContainer(
                                              child: buildDateTimeCards(
                                                  text: 'Time',
                                                  time: selectedTime ??
                                                      TimeOfDay.now()
                                                          .format(context)))),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                    CustomButton(
                        color: Color(0xff0058f9),
                        child: Text(
                          'ADD TASK',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        onPressed: () => submitReminder(notifier))
                  ],
                ),
              ),
            )));
  }

  Future<void> getSelectedDateTime() async {
    DateTime pickedDate = await pickScheduleDate(context);
    if (pickedDate != null) {
      LocalNotification.scheduleNotification(
          0,  titleController.text,contentController.text,pickedDate);
    }
  }

  submitReminder(TaskProvider provider) {
    if (selectedTime.isEmpty) {
      Fluttertoast.showToast(msg: 'Please set notification time');
      return;
    }
    Task reminder = Task(
        title: titleController.text,
        content: contentController.text,
        category: getCategory(),
        dateCreated: DateTime.now(),
        isImportant: false,
        isActive: provider.isActive,
        scheduledDate: selectedDate,
        scheduledTime: selectedTime);

    print(reminder);
    if (widget.reminder != null) {
      reminder.id = widget.reminder.id;
      provider.updateReminder(reminder);
    } else {
      provider.createReminder(reminder);
    }
    provider.getReminders();
    Navigator.of(context).pop();
  }

  Widget buildDateTimeCards({String text, String time}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            text ?? '',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Text(
            time ?? '',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget buildContainer({Widget child, double height}) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 5,
          shape: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
              height: height,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: child,
              )),
        ),
      );

//This codes are not in use but kept for reference purpose
  String getSelectedValue() {
    switch (widget.reminder.category) {
      case 'ff4caf50':
        return 'Personal';
        break;
      case 'fff44336':
        return 'Movies';
        break;
      case 'ff9c27b0':
        return 'Work';
        break;
      case 'ffffeb3b':
        return 'Sport';
        break;
      case 'ff2196f3':
        return 'Birthday';
        break;
      case 'ff607d8b':
        return 'Shopping';
        break;
      case 'ff3f51b5':
        return 'Miscellaneous';
        break;
    }
    return null;
  }
//This codes are not in use but kept for reference purpose

  String getFormattedValue(Color color) =>
      color.toString().split('(0x')[1].split(')')[0];
  getCategory() {
    String value = selectedValue.toString().split('(0x')[1].split(')')[0];

    switch (value) {
      case 'Personal':
        return getFormattedValue(Colors.green);
        break;
      case 'Movies':
        return getFormattedValue(Colors.red);
        break;
      case 'Work':
        return getFormattedValue(Colors.purple);
        break;
      case 'Sport':
        return getFormattedValue(Colors.yellow);
        break;
      case 'Birthday':
        return getFormattedValue(Colors.blue);
        break;
      case 'Shopping':
        return getFormattedValue(Colors.blueGrey);
        break;
      case 'Miscellaneous':
        return getFormattedValue(Colors.indigo);
        break;
    }
  }
}