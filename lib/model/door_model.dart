import 'dart:convert';

class DoorModel {
  final int id;
  final String doorName;

  DoorModel(this.id, this.doorName);

  int getId() {
    return this.id;
  }

  static List<DoorModel> fromJson(response) {
    List<DoorModel> doors = [];
    for (int i = 0; i < response.length; i++) {
      DoorModel door =
          DoorModel(response[i]['id'], response[i]["door_name"].toString());
      doors.add(door);
    }
    return doors;
  }

  @override
  String toString() {
    return doorName;
  }
}

class OpenDoorResponse {
  final int statusCode;
  final Map<String, dynamic> responseData;

  OpenDoorResponse(this.statusCode, this.responseData);

  static OpenDoorResponse fromJson(int statusCode, String body) {
    dynamic responseData = (jsonDecode(body));
    return new OpenDoorResponse(statusCode, responseData);
  }
}
