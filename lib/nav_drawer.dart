import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saujanapp/AddWeeklyRoutine.dart';
import 'package:saujanapp/ShowWeeklyRoutine.dart';

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
                      image: AssetImage('assets/images/cover.png'))),
            ),
            ListTile(
              leading: Icon(
                Icons.input,
                color: Colors.red,
              ),
              title: Text('Welcome', style: getTextStyle()),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Icon(
                Icons.add_circle,
                color: Colors.red,
              ),
              title: Text(
                'Add Weekly Routine',
                style: getTextStyle(),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddWeeklyRoutine(
                            currentDate: currentDateTime,
                            currentDay: currentDay,
                          )),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.library_books,
                color: Colors.red,
              ),
              title: Text(
                'Show Weekly Routine',
                style: getTextStyle(),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShowWeeklyRoutine(
                            currentDay: currentDay,
                          )),
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
