import 'package:flutter/material.dart';
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
    getToken();
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
              future: apiService.getDoors(token),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    child: Center(
                      child: Text('Loading...'),
                    ),
                  );
                } else
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, i) {
                        return ListTile(
                          title: Text(getDoorId(snapshot, i)),
                          trailing: Column(
                            children: <Widget>[
                              Expanded(
                                child: FlatButton(
                                  color: Colors.green,
                                  child: Text('Open Door'),
                                  onPressed: () => {
                                    apiService.openDoor(
                                        getDoorId(snapshot, i), token)
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

  String getDoorId(snapshot, int i) {
    return snapshot.data[i].id.toString();
  }

  getToken() {
    SharedPreferencesUtils.getSharedPreferences("token").then((token) {
      setState(() {
        this.token = token;
      });
    });
  }
}
