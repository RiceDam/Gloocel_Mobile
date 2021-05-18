import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logindemo/components/progress_hud.dart';
import 'package:logindemo/model/door_model.dart';
import '../main.dart';
import '../api/api_service.dart';
import 'package:logindemo/utils/shared_preferences.dart';

class DoorListings extends StatefulWidget {
  final String text;

  @override
  _DoorListingState createState() => _DoorListingState();

  DoorListings({Key key, @required this.text}) : super(key: key);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DoorListings(),
    );
  }
}

class _DoorListingState extends State<DoorListings> {
  String token = "";
  String ip = "10.0.2.2:8000";
  bool isApiCallProcess = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
        child: _uiSetup(context), isAsyncCall: isApiCallProcess, opacity: 0.3);
  }

  Widget _uiSetup(BuildContext context) {
    APIService apiService = new APIService();

    return Scaffold(
        appBar: AppBar(
          title: Text("Open Door"),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: (value) async {
                apiService.logout(token).then((statusCode) {
                  if (statusCode == 200) {
                    SharedPreferencesUtils.updateSharedPreferences("token", "");
                    setState(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    });
                  } else {
                    print("session expires");
                  }
                });
              },
              itemBuilder: (BuildContext context) {
                return {'Logout'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Container(
          child: Card(
            child: FutureBuilder(
              future: getDoors(apiService),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    child: Center(
                      child: Text('Loading...'),
                    ),
                  );
                }

                final items = snapshot.data;
                return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        title: Text(items[i].toString()),
                        trailing: Column(
                          children: <Widget>[
                            Expanded(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    backgroundColor: Colors.green),
                                //color: Colors.green,
                                child: Text('Open Door'),
                                onPressed: () =>
                                    {_showConfirmation(apiService, items[i])},
                              ),
                            )
                          ],
                        ),
                      );
                    });
              },
            ),
          ),
        ));
  }

  String getDoorId(DoorModel door) {
    return door.getId().toString();
  }

  Future<void> _showConfirmation(APIService apiService, DoorModel door) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Would you like to open this door?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                apiService.openDoor(getDoorId(door), this.token);

                Navigator.of(context).pop();
                setState(() {
                  // Display a message to the user that the door was opened
                  final snackBar =
                      SnackBar(content: Text("Door was successfully opened!"));
                  ScaffoldMessenger.of(this.context).showSnackBar(snackBar);

                  // Create a loading modal so the user cannot mass send messages
                  this.isApiCallProcess = true;

                  // Create a future so that the state can be updated
                  Future.delayed(const Duration(milliseconds: 3000), () {
                    setState(() {
                      this.isApiCallProcess = !this.isApiCallProcess;
                    });
                  });
                });
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Future<dynamic> getDoors(APIService apiService) async {
    this.token = await SharedPreferencesUtils.getSharedPreferences("token");
    return apiService.getDoors(this.token);
  }
}
