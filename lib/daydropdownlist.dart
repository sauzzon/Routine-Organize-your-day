import 'package:flutter/material.dart';

class DayDropDownList extends StatefulWidget {
  DayDropDownList({Key key, this.dropdownValue, this.updateDay})
      : super(key: key);
  final String dropdownValue;

  final ValueChanged<String> updateDay;
  @override
  _DayDropDownListState createState() => _DayDropDownListState();
}

class _DayDropDownListState extends State<DayDropDownList> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: Text('Hello'),
      dropdownColor: Colors.white,
      value: widget.dropdownValue,
      icon: Icon(
        Icons.arrow_downward,
        color: Colors.red,
      ),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      onChanged: (String newValue) {
        widget.updateDay(newValue);
      },
      items: <String>[
        'Sunday',
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
