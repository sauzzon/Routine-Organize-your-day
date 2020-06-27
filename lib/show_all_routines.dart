import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'show_individual_routine.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
        title: Text('Show All Routines'),
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
                  await Alert(
                    context: context,
                    type: AlertType.warning,
                    title: "ALERT",
                    desc: "Do you want to delete the routine?",
                    buttons: [
                      DialogButton(
                        child: Text(
                          "Delete",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () async {
                          int rowsEffected = await DatabaseHelper.instance
                              .delete(
                                  nameListFromDatabase[index]['personName']);
                          print(rowsEffected);
                          Navigator.pop(context);
                        },
                        color: Color.fromRGBO(0, 179, 134, 1.0),
                      ),
                      DialogButton(
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        gradient: LinearGradient(colors: [
                          Color.fromRGBO(116, 116, 191, 1.0),
                          Color.fromRGBO(52, 138, 199, 1.0)
                        ]),
                      )
                    ],
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
