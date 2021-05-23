import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:gloocel/model/door_model.dart';
import 'package:gloocel/model/login_model.dart';
import 'package:flutter_config/flutter_config.dart';

class APIService {
  final String ipAddress = FlutterConfig.get('GLOOCEL_HUB_API_URL_DEV');
  Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
    Uri url = Uri.http(ipAddress, "/api/account/login");

    try {
      var response = await http.post(url, body: requestModel.toJson());

      if (response.statusCode == 200 ||
          response.statusCode == 401 ||
          response.statusCode == 404) {
        return LoginResponseModel.fromJson(json.decode(response.body));
      }
      throw Exception("Failed to load data");
    } on SocketException catch (exception) {
      // The design of the backend Django authentication allows for multiple errors
      // So we should return an array of error messages, rather than just a single String
      return LoginResponseModel.fromJson({
        'non_field_errors': ['Unable to reach Gloocel Hub Servers'],
        'exception': exception.toString()
      });
    } catch (Exception) {
      return LoginResponseModel.fromJson({
        'non_field_errors': ['Unable to log in with provided credentials'],
        'exception': Exception.toString()
      });
    }
  }

  Future openDoor(String doorNumber, String token) async {
    Uri url = Uri.http(ipAddress, "/api/door/open/" + doorNumber);
    try {
      var response =
          await http.post(url, headers: {"Authorization": "token " + token});

      return OpenDoorResponse.fromJson(response.statusCode, response.body);
    } catch (Exception) {
      var obj = {"error": "Unable to connect to Gloocel Hub Servers"};
      return OpenDoorResponse.fromJson(500, jsonEncode(obj));
    }
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
