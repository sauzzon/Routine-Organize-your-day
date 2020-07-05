import 'dart:async';

import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'add_reminder.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Reminders extends StatefulWidget {
  @override
  _RemindersState createState() => _RemindersState();
}

class _RemindersState extends State<Reminders> {
  DateTime currentDateTime = DateTime.now();
  @override
  void initState() {
    super.initState();
    Timer.periodic(
      Duration(seconds: 1),
      (Timer t) {
        _getTime();
      },
    );

    getRemindersFromDatabase();
  }

  void _getTime() {
    final DateTime now = DateTime.now();

    if (this.mounted) {
      setState(() {
        currentDateTime = now;
      });
    }
  }

  List<Map<String, dynamic>> remindersFromDatabase = [];
  void getRemindersFromDatabase() async {
    List<Map<String, dynamic>> temp =
        await DatabaseHelper.instance.queryReminders();
    setState(() {
      remindersFromDatabase = temp;
    });
  }

  Color getCardColor(String timeText) {
    DateTime reminderTime = DateTime.parse(timeText);
    if (reminderTime.isBefore(currentDateTime))
      return Colors.orange;
    else
      return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Reminders'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: remindersFromDatabase.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: getCardColor(
                      remindersFromDatabase[index]['timeOfReminder']),
                  child: ListTile(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddReminder(
                            initialTitle: remindersFromDatabase[index]
                                ['reminderTitle'],
                            initialContent: remindersFromDatabase[index]
                                ['reminderBody'],
                            reminderID: remindersFromDatabase[index]['id'],
                            reminderTime: remindersFromDatabase[index]
                                ['timeOfReminder'],
                          ),
                        ),
                      );
                      getRemindersFromDatabase();
                    },
                    leading: Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Icon(
                        Icons.alarm,
                        color: Colors.white,
                      ),
                    ),
                    trailing: FlatButton(
                      onPressed: () async {
                        await AwesomeDialog(
                          context: context,
                          dialogType: DialogType.INFO,
                          animType: AnimType.BOTTOMSLIDE,
                          title: 'Alert',
                          desc: 'Do you want to delete this reminder?',
                          btnCancelText: 'Cancel',
                          btnCancelOnPress: () {},
                          btnOkOnPress: () async {
                            int rowsEffected = await DatabaseHelper.instance
                                .deleteReminders(
                                    remindersFromDatabase[index]['id']);
                            print(rowsEffected);
                          },
                        ).show();
                        getRemindersFromDatabase();
                      },
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(
                          top: 0, left: 20, right: 0, bottom: 0),
                      child: Text(
                        remindersFromDatabase[index]['timeOfReminder'],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    title: Padding(
                      padding: EdgeInsets.only(
                          top: 0, left: 20, right: 0, bottom: 0),
                      child: Text(
                        remindersFromDatabase[index]['reminderTitle'],
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
              builder: (context) => AddReminder(),
            ),
          );
          getRemindersFromDatabase();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }
}
