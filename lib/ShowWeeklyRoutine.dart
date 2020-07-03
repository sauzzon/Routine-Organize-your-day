import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'database_helper.dart';
import 'add_or_edit_activity.dart';

class ShowWeeklyRoutine extends StatefulWidget {
  final String currentDay;
  ShowWeeklyRoutine({Key key, this.currentDay}) : super(key: key);
  @override
  _ShowWeeklyRoutineState createState() => _ShowWeeklyRoutineState();
}

class _ShowWeeklyRoutineState extends State<ShowWeeklyRoutine> {
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
    setDayNumber();
    getNameListFromDatabase();
  }

  void setDayNumber() {
    int tempNumber = daysOfWeek.indexOf(widget.currentDay);
    setState(() {
      dayNumber = tempNumber;
    });
  }

  void _getTime() {
    final DateTime now = DateTime.now();

    if (this.mounted) {
      setState(() {
        currentDateTime = now;
      });
    }
  }

  String onlyTimeFormat(String date) {
    DateTime temp = DateTime.parse(date);
    return TimeOfDay.fromDateTime(temp).format(context);
  }

  void increaseDayNumber() {
    setState(() {
      if (dayNumber < 6) {
        dayNumber++;
      }
    });
    getNameListFromDatabase();
  }

  void decreaseDayNumber() {
    setState(() {
      if (dayNumber > 0) dayNumber--;
    });
    getNameListFromDatabase();
  }

  List<Map<String, dynamic>> nameListFromDatabase = [];

  getNameListFromDatabase() async {
    List<Map<String, dynamic>> temp =
        await DatabaseHelper.instance.queryActivities(daysOfWeek[dayNumber]);
    setState(() {
      nameListFromDatabase = temp;
    });
  }

  Color getCardColor(String startTimeText, String endTimeText) {
    if (widget.currentDay == daysOfWeek[dayNumber]) {
      DateTime temp1 = DateTime.parse(startTimeText);
      DateTime temp2 = DateTime.parse(endTimeText);
      DateTime startTime = DateTime(currentDateTime.year, currentDateTime.month,
          currentDateTime.day, temp1.hour, temp1.minute, temp1.second);
      DateTime endTime = DateTime(currentDateTime.year, currentDateTime.month,
          currentDateTime.day, temp2.hour, temp2.minute, temp2.second);
      if (startTime.isBefore(currentDateTime) &&
          endTime.isAfter(currentDateTime)) {
        return Colors.green;
      } else if (startTime.isAfter(currentDateTime)) {
        return Colors.blue[700];
      } else if (startTime.isBefore(currentDateTime) &&
          endTime.isBefore(currentDateTime)) {
        return Colors.red;
      }
    } else {
      return Colors.grey;
    }
    return null;
  }

  List<String> daysOfWeek = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];
  int dayNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weekly Routine'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: RaisedButton(
              color: Colors.blue[500],
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                decreaseDayNumber();
              },
            ),
            title: Text(
              daysOfWeek[dayNumber],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            trailing: RaisedButton(
              color: Colors.blue[500],
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
              onPressed: () {
                increaseDayNumber();
              },
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: nameListFromDatabase.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: getCardColor(nameListFromDatabase[index]['init'],
                      nameListFromDatabase[index]['fin']),
                  child: ListTile(
                    onLongPress: () async {
                      await AwesomeDialog(
                        context: context,
                        dialogType: DialogType.INFO,
                        animType: AnimType.BOTTOMSLIDE,
                        title: 'Activity selected',
                        desc: '',
                        btnCancelText: 'Edit',
                        btnOkText: 'Delete',
                        btnCancelOnPress: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddOrEditActivity(
                                        currentDate: currentDateTime,
                                        personName: daysOfWeek[dayNumber],
                                        activityName:
                                            nameListFromDatabase[index]
                                                ['actName'],
                                        activityID: nameListFromDatabase[index]
                                            ['id'],
                                      )));
                          getNameListFromDatabase();
                        },
                        btnOkOnPress: () async {
                          await AwesomeDialog(
                            context: context,
                            dialogType: DialogType.INFO,
                            animType: AnimType.BOTTOMSLIDE,
                            title: 'Alert',
                            desc: 'Do you want to delete this activity?',
                            btnCancelText: 'Cancel',
                            btnCancelOnPress: () {},
                            btnOkOnPress: () async {
                              int rowsEffected = await DatabaseHelper.instance
                                  .deleteActivity(daysOfWeek[dayNumber],
                                      nameListFromDatabase[index]['id']);
                              print(rowsEffected);
                            },
                          ).show();
                          getNameListFromDatabase();
                        },
                      ).show();
                      getNameListFromDatabase();
                    },
                    leading: Text(
                      onlyTimeFormat(nameListFromDatabase[index]['init']),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      nameListFromDatabase[index]['actName'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    trailing: Text(
                      onlyTimeFormat(nameListFromDatabase[index]['fin']),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddOrEditActivity(
                        currentDate: currentDateTime,
                        personName: daysOfWeek[dayNumber],
                        activityName: 'Add New Activity',
                      )));
          getNameListFromDatabase();
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
    );
  }
}
