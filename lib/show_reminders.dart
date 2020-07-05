import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'add_reminder.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Reminders extends StatefulWidget {
  @override
  _RemindersState createState() => _RemindersState();
}

class _RemindersState extends State<Reminders> {
  @override
  void initState() {
    super.initState();
    getRemindersFromDatabase();
  }

  List<Map<String, dynamic>> remindersFromDatabase = [];
  void getRemindersFromDatabase() async {
    List<Map<String, dynamic>> temp =
        await DatabaseHelper.instance.queryReminders();
    setState(() {
      remindersFromDatabase = temp;
    });
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
                    leading: Icon(
                      Icons.alarm,
                      color: Colors.deepOrange,
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
                        color: Colors.deepOrange,
                      ),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(
                          top: 0, left: 20, right: 0, bottom: 0),
                      child: Text(
                        remindersFromDatabase[index]['timeOfReminder'],
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
                        remindersFromDatabase[index]['reminderTitle'],
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
