import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logindemo/model/login_model.dart';

class APIService {
  Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
    Uri url = Uri.http("10.0.2.2:8000", "/api/account/login");

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
}
