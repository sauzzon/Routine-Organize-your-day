import 'package:flutter/material.dart';
import 'database_helper.dart';

class EditActivity extends StatefulWidget {
  EditActivity({Key key, this.currentDate, this.personName, this.activityName})
      : super(key: key);
  final DateTime currentDate;
  final String personName;
  final String activityName;
  @override
  _EditActivityState createState() => _EditActivityState();
}

class _EditActivityState extends State<EditActivity> {
  String _newActivityName;
  String _newInitialTime;
  String _newFinalTime;
  TextEditingController timeCtl1 = TextEditingController();
  TextEditingController timeCtl2 = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          if (picked1 != null && picked1 != time1) {
                            timeCtl1.text = picked1.format(context);

                            DateTime temp1 = DateTime(
                                widget.currentDate.year,
                                widget.currentDate.month,
                                widget.currentDate.day,
                                picked1.hour,
                                picked1.minute,
                                0);
                            _newInitialTime = temp1.toIso8601String();
                          }
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
                          if (picked2 != null && picked2 != time2) {
                            timeCtl2.text = picked2.format(context);
                            DateTime temp2 = DateTime(
                                widget.currentDate.year,
                                widget.currentDate.month,
                                widget.currentDate.day,
                                picked2.hour,
                                picked2.minute,
                                0);
                            _newFinalTime = temp2.toIso8601String();
                          }
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
                        .update(widget.personName, widget.activityName, {
                      DatabaseHelper.columnactName: _newActivityName,
                      DatabaseHelper.columnInitial: _newInitialTime,
                      DatabaseHelper.columnFinal: _newFinalTime,
                    });
                    print(updatedId);
                    Navigator.pop(context);
                  },
                  color: Colors.blue,
                  child: Text(
                    'Update',
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
