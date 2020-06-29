import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:intl/intl.dart';

class AddRoutine extends StatefulWidget {
  AddRoutine({Key key, this.currentDate}) : super(key: key);
  final DateTime currentDate;
  @override
  _AddRoutineState createState() => _AddRoutineState();
}

class _AddRoutineState extends State<AddRoutine> {
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
              if (picked1 != null && picked1 != time1) {
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
              if (picked2 != null && picked2 != time2) {
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

  String _personName;
  List<String> _actName = [];
  List<DateTime> _initTime = [];
  List<DateTime> _endTime = [];
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  List<Widget> activities = [];
  bool isPersonNameRepeated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Routine',
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
                  TextFormField(
                    style: TextStyle(
                      fontSize: 25,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Your Name',
                      hintStyle: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Name is required';
                      } else
                        return null;
                    },
                    onSaved: (String value) {
                      _personName = value;
                      print(_personName);
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: activities,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  RaisedButton(
                    color: Colors.blue,
                    onPressed: () async {
                      if (!_formkey.currentState.validate()) {
                        return;
                      }
                      _formkey.currentState.save();

                      List<Map<String, dynamic>> temp =
                          await DatabaseHelper.instance.queryPersonNames();
                      int length = temp.length;
                      for (int j = 0; j < length; j++) {
                        String caseInsensitiveName = temp[j]['personName'];
                        if (caseInsensitiveName
                                .toLowerCase()
                                .replaceAll(' ', '') ==
                            _personName.toLowerCase().replaceAll(' ', '')) {
                          isPersonNameRepeated = true;
                          break;
                        }
                      }
                      if (!isPersonNameRepeated) {
                        DatabaseHelper.instance.createNewTable(_personName);
                        DatabaseHelper.instance.insertPersonName(
                            {DatabaseHelper.columnPersonName: _personName});
                        isPersonNameRepeated = false;
                      }

                      for (int index = 0; index < _actName.length; index++) {
                        int i = await DatabaseHelper.instance
                            .insertActivities(_personName, {
                          DatabaseHelper.columnactName: _actName[index],
                          DatabaseHelper.columnInitial:
                              _initTime[index].toIso8601String(),
                          DatabaseHelper.columnFinal:
                              _endTime[index].toIso8601String(),
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            activities.add(getActivity());
          });
        },
        elevation: 0.0,
        child: Icon(Icons.add),
      ),
    );
  }
}
