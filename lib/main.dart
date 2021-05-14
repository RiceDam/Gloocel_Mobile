import 'dart:convert';
import 'dart:io' as File;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'HomePage.dart';
import 'test.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginDemo(),
    );
  }
}

class LoginDemo extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  final email = TextEditingController();
  final password = TextEditingController();
  final invalid = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('asset/images/flutter-logo.png')),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: email,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: 'Username'),

              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            FlatButton(
              onPressed: (){
                //TODO FORGOT PASSWORD SCREEN GOES HERE
              },
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () {
                  // ignore: unrelated_type_equality_checks
                  var result = authenticate(email.text, password.text);

                  result.then((value) =>
                  { if (value != null) {

                    Navigator.push(context,MaterialPageRoute(builder: (_) => test(text:value)))
                  } else {
                    print("bad creds")
                  }
                  }
                  );
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
                height: 10,
            ),
            Text('Invalid username or password',
                style: (
                    TextStyle(color: Colors.white, fontSize: 15)
                ),

    ),
            SizedBox(
              height: 130,
            ),
            Text('New User? Create Account')

          ],
        ),
      ),
    );
  }

  Future<String> authenticate(String username, String password)  async {

    var response = await http.post(
        Uri.http("10.0.2.2:8000", "/api/account/login"),
        body:{
      "username": username,
      "password": password
    });
    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      final String token = jsonData["token"];
      print(token);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", token);
      return token;
    } else{
        return null;
    }
  }
}
