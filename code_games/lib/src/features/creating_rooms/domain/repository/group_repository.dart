import 'package:code_games/src/features/creating_rooms/domain/entity/group_entity.dart';

abstract class GroupRepository {
  //To create a new room
  Future<void> createRoom(GroupEntity group) async {}

  //get all users
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    // Your code logic goes here
    return [];
  }

  //To delete a room
  Future<void> deleteRoom(GroupEntity group) async {}

  //To update a room
  Future<void> updateRoom( GroupEntity oldGroup) async {}

  // Future<List<Map<String, dynamic>>> getAllusers() async {
  //   // Your code logic goes here
  //   return [];
  // }

  //To get all the rooms
  Future<void> getAllRooms() async {}

  //To get a specific room
  Future<void> getRoom(String roomName) async {}

  //To get all the rooms in which  specific user is join or created
  Future<List<Map<String, dynamic>>> getRoomsOfUser(String userEmail) async {
    // Your code logic goes here
    return [];
  }

  //To get all the rooms created by a specific user
  Future<void> getRoomsCreatedByUser(String userName) async {}

  //To get all the rooms joined by a specific user
  Future<void> getRoomsJoinedByUser(String userName) async {}
}
