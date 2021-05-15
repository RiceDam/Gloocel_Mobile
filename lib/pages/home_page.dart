import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  final String text;
  @override
  _HomePageState createState() => _HomePageState();

  HomePage({Key key, @required this.text}) : super(key: key);

}

class _HomePageState extends State<HomePage> {
  String test = "BLAH";
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Gloocel'),
      ),
      body:
      new Container(
        child:
        new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new RaisedButton(key:null, onPressed:buttonPressed,
                  color: const Color(0xFFe0e0e0),
                  child:
                  new Text(
                    test,
                    style: new TextStyle(fontSize:40.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w200,
                        fontFamily: "Roboto"),
                  )
              ),

              new RaisedButton(key:null, onPressed:buttonPressed,
                  color: const Color(0xFFe0e0e0),
                  child:
                  new Text(
                    "DOOR 2",
                    style: new TextStyle(fontSize:40.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w200,
                        fontFamily: "Roboto"),
                  )
              ),

              new RaisedButton(key:null, onPressed:buttonPressed,
                  color: const Color(0xFFe0e0e0),
                  child:
                  new Text(
                    "DOOR 3",
                    style: new TextStyle(fontSize:40.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w200,
                        fontFamily: "Roboto"),
                  )
              ),

              new RaisedButton(key:null, onPressed:buttonPressed,
                  color: const Color(0xFFe0e0e0),
                  child:
                  new Text(
                    "DOOR 4",
                    style: new TextStyle(fontSize:40.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w200,
                        fontFamily: "Roboto"),
                  )
              )
            ]

        ),

        padding: const EdgeInsets.all(0.0),
        alignment: Alignment.center,
      ),

    );
  }
  void buttonPressed(){}

}