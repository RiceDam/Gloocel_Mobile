import 'dart:convert';

class DoorModel {
  final int id;
  final String doorName;
  final String doorType;
  final int locationId;
  final String locationName;
  final String streetNumber;
  final String streetName;
  final String city;
  final String country;

  DoorModel(this.id, this.doorName, this.doorType, this.locationId, this.locationName , this.streetNumber, this.streetName, this.city, this.country);

  int getId() {
    return this.id;
  }

  String getLocationName(){
    return this.locationName;
  }

  String getDoorName(){
    return this.doorName;
  }

  String getAddress(){
    return (this.streetNumber + " " + streetName + ", " + city);
  }
  dynamic getList(){

    return {
      "id": id,
      "door_name": doorName,
      "door_type": doorType,
      "location": {
        "id": locationId,
        "location_name": locationName,
        "street_name": streetName,
        "street_number": streetNumber,
        "city": city,
        "country": country
      }};
  }

  static List<DoorModel> fromJson(response) {
    List<DoorModel> doors = [];
    for (int i = 0; i < response.length; i++) {
      DoorModel door =
      DoorModel(response[i]['id'], response[i]["door_name"].toString(), response[i]["doorType"].toString(),
          response[i]["location"]["id"],response[i]["location"]["location_name"].toString(),
          response[i]["location"]["street_number"].toString(),response[i]["street_name"].toString(),response[i]["location"]["city"].toString(),
          response[i]["location"]["country"].toString());
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
