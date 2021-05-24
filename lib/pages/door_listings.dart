import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gloocel/components/progress_hud.dart';
import 'package:gloocel/model/door_model.dart';
import '../main.dart';
import '../api/api_service.dart';
import 'package:gloocel/utils/shared_preferences.dart';
import 'package:grouped_list/grouped_list.dart';

class DoorListings extends StatefulWidget {
  @override
  _DoorListingState createState() => _DoorListingState();

  DoorListings({Key key}) : super(key: key);
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
  bool isLoaded = false;
  String token = "";
  bool isApiCallProcess = false;
  List<dynamic> doors;

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
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: (value) async {
                apiService.logout(token).then((statusCode) {
                  SharedPreferencesUtils.updateSharedPreferences("token", "");
                  setState(() {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()));
                  });
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
                this.doors = snapshot.data;
                if (this.doors.length == 0) {
                  return Container(
                    child: Center(
                      child: Text('No doors available...'),
                    ),
                  );
                }

                return GroupedListView<dynamic, String>(
                  elements: doors,
                  groupBy: (element) => element
                      .getLocationName(), //Padding(padding:EdgeInsets.all(25.75),child:Text('${groupByValue}')),
                  groupSeparatorBuilder: (groupByValue) => new Container(
                    color: Color.fromRGBO(220, 220, 220, 100),
                    padding: EdgeInsets.all(25.75),
                    child: Text(
                      '$groupByValue',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  separator: const Divider(
                    height: 25.75,
                    color: Colors.transparent,
                  ),
                  indexedItemBuilder: (context, element, i) {
                    return ListTile(
                      contentPadding: EdgeInsets.all(15.50),
                      title: Text(element.getDoorName()),
                      trailing: Column(
                        children: <Widget>[
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: Colors.green),
                              //color: Colors.green,
                              child: Text('Open Door'),
                              onPressed: () => {
                                _showConfirmation(apiService, doors[i]),
                              },
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  itemComparator: (item1, item2) => item1
                      .getLocationName()
                      .compareTo(item2.getLocationName()), // optional
                  useStickyGroupSeparators: false, // optional
                  floatingHeader: false, // optional
                  order: GroupedListOrder.ASC, // optional
                );
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
              onPressed: () async {
                Navigator.of(context).pop();

                OpenDoorResponse res =
                    await apiService.openDoor(getDoorId(door), this.token);

                setState(() {
                  // Display a message to the user that the door was opened
                  final snackBar = SnackBar(
                      content: res.responseData.containsKey('success')
                          ? Text("Door was successfully opened!")
                          : Text("Unable to open the door at this time!"));
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
    if (isLoaded) return this.doors;

    this.token = await SharedPreferencesUtils.getSharedPreferences("token");
    this.isLoaded = true;
    return apiService.getDoors(this.token);
  }
}
