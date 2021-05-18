import 'package:flutter/material.dart';
import 'package:logindemo/model/door_model.dart';
import '../main.dart';
import '../api/api_service.dart';
import 'package:logindemo/utils/shared_preferences.dart';

class DoorListings extends StatefulWidget {
  final String text;

  @override
  _DataFromAPIState createState() => _DataFromAPIState();

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

class _DataFromAPIState extends State<DoorListings> {
  String token = "";
  String ip = "10.0.2.2:8000";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                              child: FlatButton(
                                color: Colors.green,
                                child: Text('Open Door'),
                                onPressed: () => {
                                  apiService.openDoor(
                                      getDoorId(items[i]), token)
                                },
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

  Future<dynamic> getDoors(APIService apiService) async {
    this.token = await SharedPreferencesUtils.getSharedPreferences("token");
    return apiService.getDoors(this.token);
  }
}
