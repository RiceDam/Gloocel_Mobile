import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

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

  void initState() {
    getToken();
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
  }

  Future getDoors() async {
    var response = await http.get(Uri.http("10.0.2.2:8000", "/api/door"),
        headers: {"Authorization": "token " + token});

    var jsonData = await jsonDecode(response.body);

    List<Champions> doors = [];
    for (int i = 0; i < jsonData.length; i++) {
      Champions champion =
          Champions(jsonData[i]['id'], jsonData[i]["door_name"].toString());
      print(jsonData[i]);
      doors.add(champion);
    }

    return doors;
  }

  @override
  Widget build(BuildContext context) {
    displayToken() {
      if (token != null) {
        print("Localstorage: " + token);
        return Text("Token: " + token);
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: displayToken(),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: (value) async {
                var response = await http.get(
                    Uri.http("10.0.2.2:8000", "/api/account/logout"),
                    headers: {"authorization": "Token " + token});
                if (response.statusCode == 200) {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  setState(() {
                    prefs.setString("token", "");
                    token = prefs.getString('token');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginDemo()),
                    );
                  });
                } else {
                  print("session expires");
                }
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
              future: getDoors(),
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
                          title:
                              Text(snapshot.data[i].freeChampionIds.toString()),
                          trailing: Column(
                            children: <Widget>[
                              Expanded(
                                child: FlatButton(
                                  color: Colors.green,
                                  child: Text('Open Door'),
                                  onPressed: () => {},
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
}

class Champions {
  final int id;
  final String freeChampionIds;

  Champions(this.id, this.freeChampionIds);
}
