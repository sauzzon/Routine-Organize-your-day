import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:intl/intl.dart';

class AddNote extends StatefulWidget {
  @override
  _AddNoteState createState() => _AddNoteState();
  AddNote({Key key, this.initialTitle, this.initialContent, this.noteID})
      : super(key: key);
  final String initialTitle;
  final String initialContent;
  final int noteID;
}

class _AddNoteState extends State<AddNote> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String _noteTitle;
  String _noteContent;
  bool showSaveButton = false;
  String getFormattedDateTime() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd kk:mm').format(now);
    return formattedDate;
  }

  Widget getSaveButton() {
    if (showSaveButton) {
      return RaisedButton(
        onPressed: () async {
          if (!_formkey.currentState.validate()) {
            return;
          }
          _formkey.currentState.save();
          if (widget.initialTitle == null) {
            int i = await DatabaseHelper.instance.insertNotes({
              DatabaseHelper.columnNoteTitle: _noteTitle,
              DatabaseHelper.columnNoteBody: _noteContent,
              DatabaseHelper.columnTimeOfNote: getFormattedDateTime(),
            });
            print(i);
          } else {
            int i = await DatabaseHelper.instance.updateNotes(widget.noteID, {
              DatabaseHelper.columnNoteTitle: _noteTitle,
              DatabaseHelper.columnNoteBody: _noteContent,
              DatabaseHelper.columnTimeOfNote: getFormattedDateTime(),
            });
            print(i);
          }
          Navigator.pop(context);
        },
        color: Colors.red,
        child: Text(
          'Save',
          style: TextStyle(fontSize: 17, color: Colors.white),
        ),
      );
    } else {
      return Container();
    }
  }

  String getTitleText() {
    if (widget.initialTitle == null)
      return 'Add New Note';
    else
      return 'View Note';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(getTitleText()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  onTap: () {
                    setState(() {
                      showSaveButton = true;
                    });
                  },
                  initialValue: widget.initialTitle,
                  maxLength: 25,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.orange,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Note Title',
                    hintStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.orange[200],
                    ),
                  ),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Title required';
                    } else
                      return null;
                  },
                  onSaved: (String value) {
                    _noteTitle = value;
                  },
                ),
                TextFormField(
                  onTap: () {
                    setState(() {
                      showSaveButton = true;
                    });
                  },
                  initialValue: widget.initialContent,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                    height: 1.4,
                    letterSpacing: 0.4,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Note Content',
                    hintStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.red[200],
                    ),
                  ),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Content required';
                    } else
                      return null;
                  },
                  onSaved: (String value) {
                    _noteContent = value;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                getSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
