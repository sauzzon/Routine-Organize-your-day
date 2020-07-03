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
        backgroundColor: Colors.red,
        title: Text('Show Routines'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: nameListFromDatabase.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: Colors.green,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShowIndividualRoutine(
                                  personName: nameListFromDatabase[index]
                                      ['personName'])));
                    },
                    leading: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        nameListFromDatabase[index]['personName'],
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
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
                                .delete(
                                    nameListFromDatabase[index]['personName']);
                            print(rowsEffected);
                            DatabaseHelper.instance.deleteRoutine(
                                nameListFromDatabase[index]['personName']);
                          },
                        ).show();
                        getNameListFromDatabase();
                      },
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
