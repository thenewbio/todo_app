import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mytodo/model/notes.dart';
import 'package:mytodo/provider/note_provider.dart';
import 'package:mytodo/widget/app_drawer.dart';
import 'package:mytodo/widget/new_note.dart';
import 'package:provider/provider.dart';

class TodoListScreen extends StatefulWidget {
  static const routeName = "./";
  const TodoListScreen({Key key,}) : super(key: key);

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
   Provider.of<NoteProvider>(context,listen: false).getNotes();
  }

  Widget _buildTask(Note note) {
    final textTheme = Theme.of(context).textTheme;
    return 
          InkWell(
             onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddTaskScreen(
                    note: note),
                  )),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              child: Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                                      note.title,
                                      style: textTheme.headline6.copyWith(fontWeight: FontWeight.normal)
                                    ),
                                     Text(
                                      note.content,
                                      style: textTheme.subtitle2.copyWith(fontWeight: FontWeight.normal)
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                         Text(
                  _dateFormat.format(note.dateCreated),
                  style: textTheme.headline6.copyWith(fontWeight: FontWeight.normal)
                ),
                Text(
                  "",
                  style: textTheme.headline6.copyWith(fontWeight: FontWeight.normal)
                ),
                                      ],
                                    )
                        ],
                      ),
                    ),
                    IconButton(onPressed: (){
                    Provider.of<NoteProvider>(context, listen: false).deleteNote(note.id);
                    }, icon: Icon(Icons.delete))
                  ],
                ),
              )
              
              
                // trailing: Text(
                //   widget.notes.priority,
                //   style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 15,
                //       decoration: note.status == 0
                //           ? TextDecoration.none
                //           : TextDecoration.lineThrough),
                // ),
              
              ));}
  @override
  Widget build(BuildContext context) {
    return Consumer<NoteProvider>(
       builder: (context, notifier, child) => SafeArea(
         child: Scaffold(
          appBar: AppBar(
            title: Text("My Notes"),
            centerTitle: true,
            actions:[
            ]
          ),
          drawer: AppDrawer(),
          floatingActionButton:  FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(Icons.add),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AddTaskScreen(
                            
                          )))
                          ),
          body: notifier.notes.length == 0
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Icon(Icons.notes,
                          size: 100, color:
                          Theme.of(context).brightness==Brightness.dark?
                          Colors.grey[600]:Colors.grey),
                    ),
                    Text('No Note Added',
                        style: TextStyle(
                            color: Theme.of(context).brightness==Brightness.dark?
                            Colors.grey[600]:Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 18))
                  ],
                )
                 :ListView.builder(
                    itemCount: notifier.notes.length,
                    itemBuilder: (BuildContext context, int index) {
                      final notes = notifier.notes[index];
                      return _buildTask(notes);
                    })
              ),
             )
    );
  }
}
