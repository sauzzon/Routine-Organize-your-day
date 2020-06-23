import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Result extends StatefulWidget {
  Result({Key key, this.datas}) : super(key: key);
  final List<Map<String, dynamic>> datas;
  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  DateTime currentDateTime = DateTime.now();
  @override
  void initState() {
    Timer.periodic(
      Duration(seconds: 1),
      (Timer t) {
        _getTime();
      },
    );
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Routine'),
      ),
      body: ListView.builder(
        itemCount: widget.datas.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: getCardColor(
                widget.datas[index]['init'], widget.datas[index]['fin']),
            child: ListTile(
              leading: Text(
                onlyTimeFormat(widget.datas[index]['init']),
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              title: Text(
                widget.datas[index]['actName'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                ),
              ),
              trailing: Text(
                onlyTimeFormat(widget.datas[index]['fin']),
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
