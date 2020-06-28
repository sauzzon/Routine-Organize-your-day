import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'add_or_edit_activity.dart';

class ShowIndividualRoutine extends StatefulWidget {
  ShowIndividualRoutine({Key key, this.personName}) : super(key: key);
  final String personName;
  @override
  _ShowIndividualRoutineState createState() => _ShowIndividualRoutineState();
}

class _ShowIndividualRoutineState extends State<ShowIndividualRoutine> {
  DateTime currentDateTime = DateTime.now();
  @override
  void initState() {
    super.initState();
    getActivitiesFromDatabase();
    Timer.periodic(
      Duration(seconds: 1),
      (Timer t) {
        _getTime();
      },
    );
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

  Color getCardColor(String startTimeText, String endTimeText) {
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
      return Colors.white;
    } else if (startTime.isBefore(currentDateTime) &&
        endTime.isBefore(currentDateTime)) {
      return Colors.red;
    }
    return null;
  }

  List<Map<String, dynamic>> datas = [];
  getActivitiesFromDatabase() async {
    List<Map<String, dynamic>> temp =
        await DatabaseHelper.instance.queryActivities(widget.personName);
    setState(() {
      datas = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.personName + "'s" + " Routine"),
      ),
      body: ListView.builder(
        itemCount: datas.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: getCardColor(datas[index]['init'], datas[index]['fin']),
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
                                  personName: widget.personName,
                                  activityName: datas[index]['actName'],
                                )));
                    getActivitiesFromDatabase();
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
                            .deleteActivity(
                                widget.personName, datas[index]['actName']);
                        print(rowsEffected);
                      },
                    ).show();
                    getActivitiesFromDatabase();
                  },
                ).show();
                getActivitiesFromDatabase();
              },
              leading: Text(
                onlyTimeFormat(datas[index]['init']),
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              title: Text(
                datas[index]['actName'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                ),
              ),
              trailing: Text(
                onlyTimeFormat(datas[index]['fin']),
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddOrEditActivity(
                        currentDate: currentDateTime,
                        personName: widget.personName,
                        activityName: 'Add New Activity',
                      )));
          getActivitiesFromDatabase();
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
    );
  }
}
