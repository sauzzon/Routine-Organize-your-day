import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:saujanapp/show_all_routines.dart';
import 'local_notifications.dart';
import 'database_helper.dart';
import 'addRoutine.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime currentDateTime = DateTime.now();
  @override
  void initState() {
    Timer.periodic(
      Duration(seconds: 1),
      (Timer t) {
        _getDate();
        checkNotification();
      },
    );
    super.initState();
  }

  checkNotification() async {
    List<Map<String, dynamic>> namesFromDatabase =
        await DatabaseHelper.instance.queryPersonNames();
    int len = namesFromDatabase.length;
    for (int i = 0; i < len; i++) {
      List<Map<String, dynamic>> activitiesFromDatabase = await DatabaseHelper
          .instance
          .queryActivities(namesFromDatabase[i]['personName']);
      int index = activitiesFromDatabase.length;
      for (int j = 0; j < index; j++) {
        String activityName = activitiesFromDatabase[j]['actName'];
        String startTimeText = activitiesFromDatabase[j]['init'];
        DateTime temp = DateTime.parse(startTimeText);
        DateTime startTime = DateTime(
            currentDateTime.year,
            currentDateTime.month,
            currentDateTime.day,
            temp.hour,
            temp.minute,
            temp.second);

        if (startTime.hour == currentDateTime.hour &&
            startTime.minute == currentDateTime.minute &&
            startTime.second == currentDateTime.second) {
          LocalNotification localNotification = LocalNotification();
          localNotification.showNotifications(
              namesFromDatabase[i]['personName'], activityName);
        }
      }
    }
  }

  void _getDate() {
    final DateTime now = DateTime.now();

    if (this.mounted) {
      setState(() {
        currentDateTime = now;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Daily Routine'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.red,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddRoutine(
                            currentDate: currentDateTime,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Add',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.red,
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShowAllRoutines()));
                    },
                    child: Text(
                      'Show ',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
