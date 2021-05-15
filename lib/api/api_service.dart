import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logindemo/model/login_model.dart';

class APIService {
  Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
    Uri url = Uri.http("10.0.2.2:8000", "/api/account/login");

    var response = await http.post(url, body: requestModel.toJson());

    print(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 400) {
      return LoginResponseModel.fromJson(json.decode(response.body));
    }

    throw Exception("Failed to load data");
  }
}
