import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/note_db.dart';
import '../model/notes.dart';

class AddTaskScreen extends StatefulWidget {
  final Function updateTasklist;
  final Note task;
  AddTaskScreen({this.updateTasklist, this.task});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _priority;
  String _desc = "";
  DateTime _date = DateTime.now();
  TextEditingController _dateController = TextEditingController();

  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  final List<String> _priorities = ['Low', 'Medium', 'High'];

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _title = widget.task.title;
      _date = widget.task.date;
      _desc = widget.task.time;
      _priority = widget.task.priority;
    }
    _dateController.text = _dateFormat.format(_date);
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  _handleDatePicker() async {
    final DateTime date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2060));
    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _dateController.text = _dateFormat.format(date);
    }
  }

  _delete() {
    DatabaseHelper.instance.deleteNote(widget.task.id);
    widget.updateTasklist();
    Navigator.pop(context);
  }

  _summit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print('$_title, $_date, $_desc, $_priority');

      Note task =
          Note(title: _title, date: _date, time: _desc, priority: _priority);
      if (widget.task == null) {
        task.status = 0;
        DatabaseHelper.instance.insertNote(task);
      } else {
        task.id = widget.task.id;
        task.status = widget.task.status;
        DatabaseHelper.instance.updateNote(task);
      }
      widget.updateTasklist();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios_new, size: 30),
            ),
            title: Text(
              widget.task == null ? 'Add Task' : 'Update Task',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              widget.task == null
                  ? Text('${''}')
                  : IconButton(
                      onPressed: _delete,
                      icon: Icon(Icons.delete_outline, size: 30),
                    ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                  key: _formKey,
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.always,
                        keyboardType: TextInputType.text,
                        autocorrect: true,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                            labelText: "Note Title",
                            labelStyle: TextStyle(fontSize: 18.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        validator: (input) => input.trim().isEmpty
                            ? 'Please enter a note title'
                            : null,
                        onSaved: (input) => _title = input,
                        initialValue: _title,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.always,
                        keyboardType: TextInputType.multiline,
                        autocorrect: true,
                        textInputAction: TextInputAction.done,
                        maxLines: null,
                        style: TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                          labelText: "Brief Description",
                          labelStyle: TextStyle(fontSize: 18.0),
                        ),
                        validator: (input) => input.trim().isEmpty
                            ? 'Please describe your note'
                            : null,
                        onSaved: (input) => _desc = input,
                        initialValue: _desc,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: TextFormField(
                        readOnly: true,
                        controller: _dateController,
                        style: TextStyle(fontSize: 18),
                        onTap: _handleDatePicker,
                        decoration: InputDecoration(
                            labelText: "Date",
                            labelStyle: TextStyle(fontSize: 18.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: DropdownButtonFormField(
                        isDense: true,
                        icon: Icon(Icons.arrow_drop_down_circle),
                        iconSize: 22.0,
                        items: _priorities.map((String priority) {
                          return DropdownMenuItem(
                              value: priority,
                              child: Text(
                                priority,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ));
                        }).toList(),
                        style: TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                            labelText: "Priority",
                            labelStyle: TextStyle(fontSize: 18.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        validator: (input) => _priorities == null
                            ? 'Please select a priority level'
                            : null,
                        onSaved: (input) => _priority = input,
                        onChanged: (value) {
                          setState(() {
                            _priority = value;
                          });
                        },
                        value: _priority,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: TextButton(
                          onPressed: _summit,
                          child: Text(
                            widget.task == null ? "Add" : "Update",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          )),
                    ),
                  ])),
            ),
          )),
    );
  }
}
