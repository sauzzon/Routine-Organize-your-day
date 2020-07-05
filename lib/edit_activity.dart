import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:intl/intl.dart';

class EditActivity extends StatefulWidget {
  EditActivity(
      {Key key,
      this.currentDate,
      this.day,
      this.activityName,
      this.activityID,
      this.initialTime,
      this.endTime})
      : super(key: key);
  final DateTime currentDate;
  final String day;
  final String activityName;
  final int activityID;
  final String initialTime;
  final String endTime;
  @override
  _EditActivityState createState() => _EditActivityState();
}

class _EditActivityState extends State<EditActivity> {
  String _newActivityName;
  String _newInitialTime;
  String _newFinalTime;
  TextEditingController timeCtl1;
  TextEditingController timeCtl2;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    timeCtl1 = TextEditingController(text: widget.initialTime);
    timeCtl2 = TextEditingController(text: widget.endTime);
  }

  TimeOfDay stringToTimeOfDay(String tod) {
    final format = DateFormat.jm();
    return TimeOfDay.fromDateTime(format.parse(tod));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Edit Routine'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formkey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        initialValue: widget.activityName,
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
                          _newActivityName = value;
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
                          TimeOfDay picked1 = await showTimePicker(
                              context: context, initialTime: time1);
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
                          _newInitialTime = temp1.toIso8601String();
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
                              context: context, initialTime: time2);
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
                          _newFinalTime = temp2.toIso8601String();
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
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  onPressed: () async {
                    if (!_formkey.currentState.validate()) {
                      return;
                    }
                    _formkey.currentState.save();

                    int updatedId = await DatabaseHelper.instance
                        .update(widget.day, widget.activityID, {
                      DatabaseHelper.columnactName: _newActivityName,
                      DatabaseHelper.columnInitial: _newInitialTime,
                      DatabaseHelper.columnFinal: _newFinalTime,
                    });
                    print(updatedId);

                    Navigator.pop(context);
                  },
                  color: Colors.red,
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
