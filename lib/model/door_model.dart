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
