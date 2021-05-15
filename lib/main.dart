import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logindemo/api/api_service.dart';
import 'package:logindemo/components/progress_hud.dart';
import 'package:logindemo/pages/door_listings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/login_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  LoginRequestModel requestModel;
  bool isApiCallProcess = false;

  @override
  void initState() {
    super.initState();
    requestModel = new LoginRequestModel();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
        child: _uiSetup(context), isAsyncCall: isApiCallProcess, opacity: 0.3);
  }

  Widget _uiSetup(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                      hintText: 'Username'),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (input) => requestModel.username = input,
                  validator: (input) => !input.contains("@")
                      ? "Invalid email address provided"
                      : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter secure password'),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  onSaved: (input) => requestModel.password = input,
                  validator: (input) => input.length < 6
                      ? "Password should be more than 6 characters"
                      : null,
                ),
              ),
              TextButton(
                onPressed: () {
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
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: ElevatedButton(
                  onPressed: () {
                    if (validateAndSave()) {
                      setState(() {
                        isApiCallProcess = true;
                      });

                      APIService apiService = new APIService();
                      apiService.login(requestModel).then((value) {
                        setState(() {
                          isApiCallProcess = false;
                        });

                        if (value.token.isNotEmpty) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      DoorListings(text: value.token)));
                        } else {
                          final snackBar = SnackBar(content: Text(value.error));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      });
                    }
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
              Text(
                'Invalid username or password',
                style: (TextStyle(color: Colors.white, fontSize: 15)),
              ),
              SizedBox(
                height: 130,
              ),
              //Text('New User? Create Account')
            ],
          ),
        ),
      ),
    );
  }

  Future<String> authenticate(String username, String password) async {
    var response = await http.post(
        Uri.http("10.0.2.2:8000", "/api/account/login"),
        body: {"username": username, "password": password});
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      final String token = jsonData["token"];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", token);
      return token;
    } else {
      return null;
    }
  }

  bool validateAndSave() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
