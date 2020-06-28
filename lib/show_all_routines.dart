import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'show_individual_routine.dart';

import 'package:awesome_dialog/awesome_dialog.dart';

class ShowAllRoutines extends StatefulWidget {
  @override
  _ShowAllRoutinesState createState() => _ShowAllRoutinesState();
}

class _ShowAllRoutinesState extends State<ShowAllRoutines> {
  @override
  void initState() {
    super.initState();
    getNameListFromDatabase();
  }

  List<Map<String, dynamic>> nameListFromDatabase = [];
  getNameListFromDatabase() async {
    List<Map<String, dynamic>> temp =
        await DatabaseHelper.instance.queryPersonNames();
    setState(() {
      nameListFromDatabase = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Routines'),
      ),
      body: ListView.builder(
        itemCount: nameListFromDatabase.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShowIndividualRoutine(
                            personName: nameListFromDatabase[index]
                                ['personName'])));
              },
              leading: Icon(Icons.person),
              title: Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(
                  nameListFromDatabase[index]['personName'],
                ),
              ),
              trailing: FlatButton(
                onPressed: () async {
                  await AwesomeDialog(
                    context: context,
                    dialogType: DialogType.INFO,
                    animType: AnimType.BOTTOMSLIDE,
                    title: 'Alert',
                    desc: 'Do you want to delete the routine?',
                    btnCancelOnPress: () {},
                    btnOkOnPress: () async {
                      int rowsEffected = await DatabaseHelper.instance
                          .delete(nameListFromDatabase[index]['personName']);
                      print(rowsEffected);
                    },
                  ).show();
                  getNameListFromDatabase();
                },
                child: Icon(
                  Icons.delete,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
