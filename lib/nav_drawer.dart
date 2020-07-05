import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saujanapp/add_routine.dart';
import 'package:saujanapp/show_routine.dart';
import 'package:saujanapp/show_notes.dart';
import 'package:saujanapp/show_reminders.dart';

class NavDrawer extends StatelessWidget {
  final DateTime currentDateTime;
  final String currentDay;
  NavDrawer({this.currentDateTime, this.currentDay});
  TextStyle getTextStyle() {
    return TextStyle(fontSize: 15, letterSpacing: 0.5);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Container(),
              decoration: BoxDecoration(
                color: Colors.red,
                image: DecorationImage(
                  image: AssetImage('assets/images/cover.png'),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.calendar_today,
                color: Colors.red,
              ),
              title: Text(
                'Daily Routine',
                style: getTextStyle(),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShowDailyRoutine(
                            currentDay: currentDay,
                          )),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.assignment,
                color: Colors.red,
              ),
              title: Text(
                'Notes',
                style: getTextStyle(),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Notes(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.alarm,
                color: Colors.red,
              ),
              title: Text(
                'Reminders',
                style: getTextStyle(),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Reminders(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Colors.red,
              ),
              title: Text(
                'Settings',
                style: getTextStyle(),
              ),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.red,
              ),
              title: Text(
                'Exit',
                style: getTextStyle(),
              ),
              onTap: () => {SystemNavigator.pop()},
            ),
          ],
        ),
      ),
    );
  }
}
