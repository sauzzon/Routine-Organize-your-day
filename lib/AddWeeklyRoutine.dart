import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'daydropdownlist.dart';
import 'database_helper.dart';

class AddWeeklyRoutine extends StatefulWidget {
  @override
  _AddWeeklyRoutineState createState() => _AddWeeklyRoutineState();
  AddWeeklyRoutine({Key key, this.currentDate, this.currentDay})
      : super(key: key);
  final DateTime currentDate;
  final String currentDay;
}

class _AddWeeklyRoutineState extends State<AddWeeklyRoutine> {
  @override
  void initState() {
    super.initState();
    dropdownValue = widget.currentDay;
  }

  void updateDay(String newValue) {
    setState(() {
      dropdownValue = newValue;
    });
  }

  TimeOfDay stringToTimeOfDay(String tod) {
    final format = DateFormat.jm();
    return TimeOfDay.fromDateTime(format.parse(tod));
  }

  Widget getActivity() {
    TextEditingController timeCtl1 = TextEditingController();
    TextEditingController timeCtl2 = TextEditingController();
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: TextFormField(
            style: TextStyle(
              fontSize: 20,
            ),
            decoration: InputDecoration(hintText: 'Activity'),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Activity required';
              } else
                return null;
            },
            onSaved: (String value) {
              _actName.add(value);
            },
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          flex: 1,
          child: TextFormField(
            controller: timeCtl1,
            decoration: InputDecoration(
              hintText: 'Time',
            ),
            onTap: () async {
              TimeOfDay time1 = TimeOfDay.now();
              FocusScope.of(context).requestFocus(new FocusNode());
              TimeOfDay picked1 =
                  await showTimePicker(context: context, initialTime: time1);
              if (picked1 != null) {
                timeCtl1.text = picked1.format(context);
              }
            },
            onSaved: (String tod) {
              TimeOfDay startTime = stringToTimeOfDay(tod);
              DateTime temp1 = DateTime(
                  widget.currentDate.year,
                  widget.currentDate.month,
                  widget.currentDate.day,
                  startTime.hour,
                  startTime.minute,
                  0);
              _initTime.add(temp1);
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Cant be empty';
              }
              return null;
            },
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 1,
          child: TextFormField(
            controller: timeCtl2,
            decoration: InputDecoration(
              hintText: 'Time',
            ),
            onTap: () async {
              TimeOfDay time2 = TimeOfDay.now();
              FocusScope.of(context).requestFocus(new FocusNode());
              TimeOfDay picked2 = await showTimePicker(
                context: context,
                initialTime: time2,
              );
              if (picked2 != null) {
                timeCtl2.text = picked2.format(context);
              }
            },
            onSaved: (String tod) {
              TimeOfDay endTime = stringToTimeOfDay(tod);
              DateTime temp2 = DateTime(
                  widget.currentDate.year,
                  widget.currentDate.month,
                  widget.currentDate.day,
                  endTime.hour,
                  endTime.minute,
                  0);
              _endTime.add(temp2);
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Cant be empty';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget getSaveButton() {
    if (showSaveButton) {
      return RaisedButton(
        color: Colors.red,
        onPressed: () async {
          if (!_formkey.currentState.validate()) {
            return;
          }
          _formkey.currentState.save();
          for (int index = 0; index < _actName.length; index++) {
            int i =
                await DatabaseHelper.instance.insertActivities(dropdownValue, {
              DatabaseHelper.columnactName: _actName[index],
              DatabaseHelper.columnInitial: _initTime[index].toIso8601String(),
              DatabaseHelper.columnFinal: _endTime[index].toIso8601String(),
            });
            print('the inserted id is $i');
          }
          Navigator.pop(context);
        },
        child: Text(
          'Save',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  bool showSaveButton = false;
  String dropdownValue;
  List<String> _actName = [];
  List<DateTime> _initTime = [];
  List<DateTime> _endTime = [];
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  List<Widget> activities = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Add Weekly Routine',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            child: Form(
              key: _formkey,
              child: Column(
                children: <Widget>[
                  DayDropDownList(
                    dropdownValue: dropdownValue,
                    updateDay: updateDay,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: activities,
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
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          showSaveButton = true;
          setState(() {
            activities.add(getActivity());
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
