import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'addRoutine.dart';
import 'show_all_routines.dart';

class NavDrawer extends StatelessWidget {
  final DateTime currentDateTime;
  NavDrawer({this.currentDateTime});
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
                'Add Routine',
                style: getTextStyle(),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddRoutine(
                      currentDate: currentDateTime,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.library_books,
                color: Colors.red,
              ),
              title: Text(
                'Show Routines',
                style: getTextStyle(),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ShowAllRoutines()));
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
