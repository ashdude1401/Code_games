import 'package:code_games/src/features/creating_rooms/domain/entity/group_entity.dart';

abstract class GroupRepository {
  //To create a new room
  Future<void> createRoom(GroupEntity group, List<Channel> channels) async {}

  //get all users
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    // Your code logic goes here
    return [];
  }

  //To delete a room
  Future<void> deleteRoom(GroupEntity group) async {}

  //To update a room
  Future<void> updateRoom(GroupEntity oldGroup) async {}

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

  //----------------------Group sepcific operations----------------------//
  //Add members to a group

  Future<void> addMembersToRoom(
      String groupId, List<GroupMembers> members) async {}
  //Remove members from a group

  Future<void> removeMembersFromRoom(
      String groupId, List<GroupMembers> members) async {}

  Future<void> leaveRoom(String groupId, String userEmail) async {}

  Future<void> createChannel(String groupId, Channel channel) async {}

  Future<List<Map<String, dynamic>>> getChannelOfGroup(String groupId) async {
    return [];
  }

  Future<void> getChatsOfGroup(String groupId, String channelId) async {}

  Future<void> sendMessage(
      String groupId, String channelId, Message message) async {}

  Future<void> deleteMessage(
      String groupId, String channelId, String messageId) async {}

  
  //Add admins to a group

  //Remove admins from a group

  //Add challenges to a group

  //Remove challenges from a group

  //Update group details

  //Get all the members of a group

  //Get all the admins of a group

  //Get all the challenges of a group

  //Get all the messages of a group
}
