import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'nav_drawer.dart';
import 'package:intl/intl.dart';
import 'local_notifications.dart';
import 'database_helper.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime currentDateTime = DateTime.now();
  String currentDay;
  @override
  void initState() {
    Timer.periodic(
      Duration(seconds: 1),
      (Timer t) {
        _getDate();
        checkNotifications();
      },
    );
    super.initState();
  }

  void _getDate() {
    final DateTime now = DateTime.now();

    if (this.mounted) {
      setState(() {
        currentDateTime = now;
        currentDay = DateFormat('EEEE').format(now);
      });
    }
  }

  void checkNotifications() async {
    List<Map<String, dynamic>> activitiesFromDatabase =
        await DatabaseHelper.instance.queryActivities(currentDay);
    int index = activitiesFromDatabase.length;
    for (int j = 0; j < index; j++) {
      String activityName = activitiesFromDatabase[j]['actName'];
      String startTimeText = activitiesFromDatabase[j]['init'];
      DateTime temp = DateTime.parse(startTimeText);
      DateTime startTime = DateTime(currentDateTime.year, currentDateTime.month,
          currentDateTime.day, temp.hour, temp.minute, temp.second);

      if (startTime.hour == currentDateTime.hour &&
          startTime.minute == currentDateTime.minute &&
          startTime.second == currentDateTime.second) {
        LocalNotification localNotification = LocalNotification();
        localNotification.showNotifications('Routine', activityName);
      }
    }
    List<Map<String, dynamic>> remindersFromDatabase =
        await DatabaseHelper.instance.queryReminders();
    int newIndex = remindersFromDatabase.length;
    for (int i = 0; i < newIndex; i++) {
      String reminderTitle = remindersFromDatabase[i]['reminderTitle'];
      String reminderTimeText = remindersFromDatabase[i]['timeOfReminder'];
      DateTime reminderTime = DateTime.parse(reminderTimeText);
      if (reminderTime.year == currentDateTime.year &&
          reminderTime.month == currentDateTime.month &&
          reminderTime.day == currentDateTime.day &&
          reminderTime.hour == currentDateTime.hour &&
          reminderTime.minute == currentDateTime.minute &&
          reminderTime.second == currentDateTime.second) {
        LocalNotification localNotification = LocalNotification();
        localNotification.showNotifications('Reminder', reminderTitle);
      }
    }
  }

  List<String> bottomTexts = [
    'Organize your Daily Activities',
    'Keep record of everything',
    'Do not miss anything',
    'Be updated and organized'
  ];
  List<String> topTexts = [
    'Daily Routine',
    'Notes',
    'Reminders',
    'Get Started'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(
        currentDateTime: currentDateTime,
        currentDay: currentDay,
      ),
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Homepage',
        ),
      ),
      body: Swiper(
        autoplay: true,
        autoplayDelay: 4000,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.orange,
                    constraints: BoxConstraints.expand(),
                    child: Center(
                      child: Text(
                        topTexts[index],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )),
              Expanded(
                flex: 10,
                child: Image(
                  fit: BoxFit.fill,
                  image: AssetImage(
                    'assets/images/routine$index.png',
                  ),
                ),
              ),
              Expanded(
                  flex: 4,
                  child: Container(
                    color: Colors.deepOrangeAccent,
                    child: Center(
                      child: Text(
                        bottomTexts[index],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )),
            ],
          );
        },
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        //control: SwiperControl(color: Colors.blue, size: 30),
        pagination: SwiperPagination(),
        controller: SwiperController(),
      ),
    );
  }
}
