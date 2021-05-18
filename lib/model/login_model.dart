class LoginResponseModel {
  final String token;
  final String error;

  LoginResponseModel({this.token, this.error});

  // Factory keyword is used when a constructor does not create a new instance of its class
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
        token: json["token"] != null ? json["token"] : "",
        error: json["non_field_errors"] != null
            ? json["non_field_errors"][0]
            : "");
  }
}

class LoginRequestModel {
  String username;
  String password;

  LoginRequestModel({this.username, this.password});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'username': username != null ? username.trim() : "",
      'password': password != null ? password.trim() : "",
    };
    return map;
  }
}
