import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logindemo/model/door_model.dart';
import 'package:logindemo/model/login_model.dart';

class APIService {
  final String ipAddress = "10.0.2.2:8000";
  Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
    Uri url = Uri.http(ipAddress, "/api/account/login");

    try {
      var response = await http.post(url, body: requestModel.toJson());

      if (response.statusCode == 200 || response.statusCode == 400) {
        return LoginResponseModel.fromJson(json.decode(response.body));
      }
    } catch (SocketException) {
      // The design of the backend Django authentication allows for multiple errors
      // So we should return an array of error messages, rather than just a single String
      return LoginResponseModel.fromJson({
        'non_field_errors': ['Unable to reach Gloocel Hub Servers']
      });
    }

    throw Exception("Failed to load data");
  }

  Future openDoor(String doorNumber, String token) async {
    Uri url = Uri.http(ipAddress, "/api/door/open/" + doorNumber);
    try {
      var response =
          await http.post(url, headers: {"Authorization": "token " + token});
    } catch (SocketException) {}
  }

  Future<List<dynamic>> getDoors(String token) async {
    Uri url = Uri.http(ipAddress, "/api/door/");
    try {
      var response =
          await http.get(url, headers: {"Authorization": "token " + token});

      if (response.statusCode == 401) {
        return [];
      }

      if (response.statusCode == 200 || response.statusCode == 400) {
        return DoorModel.fromJson(json.decode(response.body));
      }
    } catch (Exception) {
      return [];
    }

    return [];
  }

  Future<int> logout(String token) async {
    Uri url = Uri.http(ipAddress, "/api/account/logout");
    var response =
        await http.get(url, headers: {"authorization": "Token " + token});
    return response.statusCode;
  }
}
