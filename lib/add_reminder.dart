import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:intl/intl.dart';

class AddReminder extends StatefulWidget {
  @override
  _AddReminderState createState() => _AddReminderState();
  AddReminder({
    Key key,
    this.initialTitle,
    this.initialContent,
    this.reminderID,
    this.reminderTime,
  }) : super(key: key);
  final String initialTitle;
  final String initialContent;
  final int reminderID;
  final String reminderTime;
}

class _AddReminderState extends State<AddReminder> {
  @override
  void initState() {
    super.initState();
    dateController = TextEditingController(text: widget.reminderTime);
  }

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String _reminderTitle;
  String _reminderContent;
  String _reminderTime;
  bool showSaveButton = false;
  TextEditingController dateController;
  String getFormattedDateTime(DateTime now) {
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
            int i = await DatabaseHelper.instance.insertReminders({
              DatabaseHelper.columnReminderTitle: _reminderTitle,
              DatabaseHelper.columnReminderBody: _reminderContent,
              DatabaseHelper.columnTimeOfReminder: _reminderTime,
            });
            print(i);
          } else {
            int i = await DatabaseHelper.instance
                .updateReminders(widget.reminderID, {
              DatabaseHelper.columnReminderTitle: _reminderTitle,
              DatabaseHelper.columnReminderBody: _reminderContent,
              DatabaseHelper.columnTimeOfReminder: _reminderTime,
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
      return 'Add New Reminder';
    else
      return 'View Reminder';
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
                    hintText: 'Reminder Title',
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
                    _reminderTitle = value;
                  },
                ),
                TextFormField(
                  maxLength: 50,
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
                    hintText: 'Reminder Content',
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
                    _reminderContent = value;
                  },
                ),
                TextFormField(
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.orange,
                    height: 1.4,
                    letterSpacing: 0.4,
                  ),
                  controller: dateController,
                  decoration: InputDecoration(
                      hintText: 'Reminder Date and Time',
                      hintStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.orange[200],
                      )),
                  onTap: () async {
                    showSaveButton = true;
                    TimeOfDay time = TimeOfDay.now();
                    DateTime date = DateTime.now();
                    FocusScope.of(context).requestFocus(new FocusNode());
                    DateTime pickedDate = await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime(2015, 1),
                        lastDate: DateTime(2050, 12));
                    TimeOfDay pickedTime = await showTimePicker(
                        context: context, initialTime: time);
                    if (pickedTime != null && pickedDate != null) {
                      DateTime pickedDateTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                          0);
                      String formattedDateTime =
                          getFormattedDateTime(pickedDateTime);
                      dateController.text = formattedDateTime;
                    }
                  },
                  onSaved: (String value) {
                    String formattedDateTime =
                        getFormattedDateTime(DateTime.parse(value));
                    _reminderTime = formattedDateTime;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Cant be empty';
                    }
                    return null;
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
