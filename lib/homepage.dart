import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'nav_drawer.dart';
import 'package:intl/intl.dart';
import 'local_notifications.dart';
import 'database_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime currentDateTime = DateTime.now();
  String currentDay;
  @override
  void initState() {
    Timer.periodic(
      Duration(seconds: 1),
      (Timer t) {
        _getDate();
        checkNotifications();
      },
    );
    super.initState();
  }

  void _getDate() {
    final DateTime now = DateTime.now();

    if (this.mounted) {
      setState(() {
        currentDateTime = now;
        currentDay = DateFormat('EEEE').format(now);
      });
    }
  }

  void checkNotifications() async {
    List<Map<String, dynamic>> activitiesFromDatabase =
        await DatabaseHelper.instance.queryActivities(currentDay);
    int index = activitiesFromDatabase.length;
    for (int j = 0; j < index; j++) {
      String activityName = activitiesFromDatabase[j]['actName'];
      String startTimeText = activitiesFromDatabase[j]['init'];
      DateTime temp = DateTime.parse(startTimeText);
      DateTime startTime = DateTime(currentDateTime.year, currentDateTime.month,
          currentDateTime.day, temp.hour, temp.minute, temp.second);

      if (startTime.hour == currentDateTime.hour &&
          startTime.minute == currentDateTime.minute &&
          startTime.second == currentDateTime.second) {
        LocalNotification localNotification = LocalNotification();
        localNotification.showNotifications('Routine', activityName);
      }
    }
    List<Map<String, dynamic>> remindersFromDatabase =
        await DatabaseHelper.instance.queryReminders();
    int newIndex = remindersFromDatabase.length;
    for (int i = 0; i < newIndex; i++) {
      String reminderTitle = remindersFromDatabase[i]['reminderTitle'];
      String reminderTimeText = remindersFromDatabase[i]['timeOfReminder'];
      DateTime reminderTime = DateTime.parse(reminderTimeText);
      if (reminderTime.year == currentDateTime.year &&
          reminderTime.month == currentDateTime.month &&
          reminderTime.day == currentDateTime.day &&
          reminderTime.hour == currentDateTime.hour &&
          reminderTime.minute == currentDateTime.minute &&
          reminderTime.second == currentDateTime.second) {
        LocalNotification localNotification = LocalNotification();
        localNotification.showNotifications('Reminder', reminderTitle);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(
        currentDateTime: currentDateTime,
        currentDay: currentDay,
      ),
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Daily Routine'),
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Image(
                      image: AssetImage('assets/images/routine1.png'),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Routine - Organize your day',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: Image(
                      image: AssetImage('assets/images/routine2.png'),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
