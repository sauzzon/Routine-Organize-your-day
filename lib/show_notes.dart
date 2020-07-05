import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'add_new_note.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Notes extends StatefulWidget {
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  @override
  void initState() {
    super.initState();
    getNotesFromDatabase();
  }

  List<Map<String, dynamic>> notesFromDatabase = [];
  void getNotesFromDatabase() async {
    List<Map<String, dynamic>> temp =
        await DatabaseHelper.instance.queryNotes();
    setState(() {
      notesFromDatabase = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Notes'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notesFromDatabase.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNote(
                            initialTitle: notesFromDatabase[index]['noteTitle'],
                            initialContent: notesFromDatabase[index]
                                ['noteBody'],
                            noteID: notesFromDatabase[index]['id'],
                          ),
                        ),
                      );
                      getNotesFromDatabase();
                    },
                    leading: Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Icon(
                        Icons.assignment,
                        color: Colors.deepOrange,
                      ),
                    ),
                    trailing: FlatButton(
                      onPressed: () async {
                        await AwesomeDialog(
                          context: context,
                          dialogType: DialogType.INFO,
                          animType: AnimType.BOTTOMSLIDE,
                          title: 'Alert',
                          desc: 'Do you want to delete this note?',
                          btnCancelText: 'Cancel',
                          btnCancelOnPress: () {},
                          btnOkOnPress: () async {
                            int rowsEffected = await DatabaseHelper.instance
                                .deleteNotes(notesFromDatabase[index]['id']);
                            print(rowsEffected);
                          },
                        ).show();
                        getNotesFromDatabase();
                      },
                      child: Icon(
                        Icons.delete,
                        color: Colors.deepOrange,
                      ),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(
                          top: 0, left: 20, right: 0, bottom: 0),
                      child: Text(
                        notesFromDatabase[index]['timeOfNote'],
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    title: Padding(
                      padding: EdgeInsets.only(
                          top: 0, left: 20, right: 0, bottom: 0),
                      child: Text(
                        notesFromDatabase[index]['noteTitle'],
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNote(),
            ),
          );
          getNotesFromDatabase();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }
}
