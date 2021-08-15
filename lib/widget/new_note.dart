import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mytodo/model/notes.dart';
import 'package:mytodo/provider/note_provider.dart';
import 'package:provider/provider.dart';

class AddTaskScreen extends StatefulWidget {
  final Note note;
  AddTaskScreen({ this.note});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _date = DateTime.now();
  TextEditingController _dateController = TextEditingController();
   var titleController = new TextEditingController();
  var contentController = new TextEditingController();

  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');


  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleController.text = widget.note.title;
      contentController.text = widget.note.content;
      _date = widget.note.dateCreated;
    
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

 _summit(NoteProvider provider) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print('$titleController, $_date, $contentController,');
     

   Note note = Note(content: contentController.text, title: titleController.text, dateCreated: _date);
      if (widget.note != null) {
        note.id = widget.note.id;
       provider.updateNotes(note);
      } else {
       provider.createNote(note);
      }
      provider.getNotes();
      Navigator.pop(context);
    }
  }
     

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteProvider>(
       builder: (context, notifier, child) => SafeArea(
        child: Scaffold(
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 30,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget.note == null ? 'Add Note' : 'Update Note',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Form(
                        key: _formKey,
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: TextFormField(
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                  labelText: "Title",
                                  labelStyle: TextStyle(fontSize: 18.0),),
                              validator: (input) => input.trim().isEmpty
                                  ? 'Please enter a task title'
                                  : null,
                              onSaved: (input) => titleController.text = input,
                              initialValue: titleController.text,
                            ),
                          ),
                           Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: TextFormField(
                              keyboardType:  TextInputType.multiline,
                              maxLines: null,
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                  labelText: "Desc",
                                  labelStyle: TextStyle(fontSize: 18.0),
                                 ),
                              validator: (input) => input.trim().isEmpty
                                  ? 'Describe your note'
                                  : null,
                              onSaved: (input) => contentController.text = input,
                              initialValue: contentController.text,
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
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 20.0),
                            height: 60,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: TextButton(
                                onPressed:(){
                                  _summit(notifier);
                                },
                                child: Text(
                                  widget.note == null ? "Add" : "Update",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0),
                                )),
                          ),
                          widget.note != null
                              ? Container(
                                  margin: EdgeInsets.symmetric(vertical: 20.0),
                                  height: 60,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: TextButton(
                                      onPressed: () {
                                      
                                      } ,
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20.0),
                                      )),
                                )
                              : SizedBox.shrink()
                        ]))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
