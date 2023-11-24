import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_games/src/features/auth/data/repository/authentication_repository_impl.dart';
import 'package:code_games/src/features/creating_rooms/data/repository/exception/firestore_expception.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:get/get.dart';

import '../../domain/entity/group_entity.dart';
import '../../domain/repository/Group_repository.dart';

class GroupRepositoryImpl extends GetxController implements GroupRepository {
  //Intializing firestore instance to perform CRUD operations on the database

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final storage = FirebaseStorage.instance;

  @override
  Future<void> createRoom(GroupEntity group, List<Channel> channels) async {
    try {
      //creating a Unique id for the group
      group.groupId = firestore.collection('groups').doc().id;
      //creating a group document with the group id and adding the group data to it
      await firestore
          .collection('groups')
          .doc(group.groupId)
          .set(group.toMap());

      print('group created');

      List<String> channelIds = [];
      //creating a channel document with the group id and adding the channel data to it
      for (var channel in channels) {
        //creating a Unique id for the channel
        channel.channelId = firestore.collection('groups').doc().id;
        await firestore
            .collection('groups')
            .doc(group.groupId)
            .collection('channels')
            .doc(channel.channelId)
            .set(channel.toMap());
        channelIds.add(channel.channelId);
      }
      //adding the channel ids to the group document
      await firestore
          .collection('groups')
          .doc(group.groupId)
          .update({'channels': channelIds});
      print('channel created');

      // List<String> messageReffernceId = [];
      //creating messages collection for each channel
      for (var channel in channels) {
        //creating a Unique id for the message
        final messageId = firestore
            .collection('groups')
            .doc(group.groupId)
            .collection('channels')
            .doc(channel.channelId)
            .collection('messages')
            .doc()
            .id;

        // //adding the message reference id to the channel messagesReferenceId
        // messageReffernceId.add(messageId);

        //creating a message document with the message id and adding the message data to it
        await firestore
            .collection('groups')
            .doc(group.groupId)
            .collection('channels')
            .doc(channel.channelId)
            .collection('messages')
            .doc(messageId)
            .set({
          'messageId': messageId,
          'senderId':
              AuthenticationRepositoryImpl.instance.currentUser.value.userID,
          'messageText': 'Welcome to ${group.groupName}',
          'timestamp': DateTime.now().toIso8601String(),
          'senderEmail':
              AuthenticationRepositoryImpl.instance.currentUser.value.email,
          'senderName':
              AuthenticationRepositoryImpl.instance.currentUser.value.fullName,
          'senderImg': AuthenticationRepositoryImpl
              .instance.currentUser.value.profilePicture,
        });
        await firestore
            .collection('groups')
            .doc(group.groupId)
            .collection('channels')
            .doc(channel.channelId)
            .update({'messagesReferenceId': messageId});
      }

      //adding the message reference id to the channel messagesReferenceId

      print('messages created');
      // DocumentReference groupDocRef =
      //   await firestore.collection('groups').add(group.toMap());

      // Updating the list of groups created by the user
      QuerySnapshot userSnapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: group.createdBy)
          .get();

      print('user grouplist updated');

      if (userSnapshot.docs.isNotEmpty) {
        String userId = userSnapshot.docs.first.id;
        await firestore.collection('users').doc(userId).update({
          'groups': FieldValue.arrayUnion([group.groupId]),
        });

        // Get.off(() => HomeView());
        Get.back();

        Get.snackbar('Success', 'Room Created Successfully');
      } else {
        Get.snackbar('Error', 'User not found',
            snackPosition: SnackPosition.BOTTOM);
      }
    } on FirebaseException catch (e) {
      // Handle Firebase exceptions here
      print('Firebase Exception: ${e.message}');
      FirestoreDbFailure.code(e.code);
      Get.snackbar('Error', 'Failed to create room: ${e.message}',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      // Handle other exceptions here
      print('Exception: $e');
      Get.snackbar(
        'Error',
        'Failed to create room: $e',
      );
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getRoomsOfUser(String userEmail) async {
    List<Map<String, dynamic>> userRooms = [];
    try {
      // Getting the user with the email id
      var userSnapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        userRooms.clear();
        for (var element in userSnapshot.docs) {
          // Getting the list of group id created by the user or joined by the user
          var groups = element['groups'] ??
              <String>[]; // Use an empty list if 'groups' is null

          if (groups.isNotEmpty) {
            // Getting the group details of each group id
            var groupsSnapshot = await firestore
                .collection('groups')
                .where('groupId', whereIn: groups)
                .get();

            if (groupsSnapshot.docs.isNotEmpty) {
              for (var groupElement in groupsSnapshot.docs) {
                userRooms.add(groupElement.data());
                print(
                    "----------userRoom from getRoomsofUser -------------------${groupElement.data()}");
              }
            } else {
              print(
                  "User has no groups."); // Log or handle the case where the user has no groups
            }
          }
        }
      }
    } on FirebaseException catch (e) {
      final errMsg = FirestoreDbFailure.code(e.code).message;
      Get.snackbar('Error', errMsg, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error Room Not Found', e.toString(),
          snackPosition: SnackPosition.BOTTOM);

      print("Error: $e");
    }
    return userRooms;
  }

  Future<GroupEntity> getGroup(String joinId) async {
    GroupEntity group = GroupEntity(
      groupId: '',
      groupName: '',
      groupDescription: '',
      groupImg: '',
      challengesRefferenceId: [],
      groupMembers: [],
      admins: [],
      createdBy: '',
      channelReferenceId: [],
      uniqueJoinId: '',
    );
    try {
      // Getting the user with the email id
      var groupSnapshot = await firestore
          .collection('groups')
          .where('uniqueJoinId', isEqualTo: joinId)
          .get();

      if (groupSnapshot.docs.isNotEmpty) {
        for (var element in groupSnapshot.docs) {
          group = GroupEntity.fromMap(element.data());
        }
      }
    } on FirebaseException catch (e) {
      final errMsg = FirestoreDbFailure.code(e.code).message;
      Get.snackbar('Error', errMsg, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error Room Not Found', e.toString(),
          snackPosition: SnackPosition.BOTTOM);

      print("Error: $e");
    }
    return group;
  }

  @override
  Future<void> deleteRoom(GroupEntity group) {
    // TODO: implement deleteRoom
    throw UnimplementedError();
  }

  @override
  Future<void> getAllRooms() {
    // TODO: implement getAllRooms
    throw UnimplementedError();
  }

  @override
  Future<void> getRoom(String roomName) {
    // TODO: implement getRoom
    throw UnimplementedError();
  }

  @override
  Future<void> getRoomsCreatedByUser(String userName) {
    // TODO: implement getRoomsCreatedByUser
    throw UnimplementedError();
  }

  @override
  Future<void> getRoomsJoinedByUser(String userName) {
    // TODO: implement getRoomsJoinedByUser
    throw UnimplementedError();
  }

  @override
  Future<void> updateRoom(GroupEntity newGroup) async {
    try {
      await firestore
          .collection('groups')
          .doc(newGroup.groupId)
          .update(newGroup.toMap());
    } on FirestoreDbFailure catch (e) {
      Get.snackbar('Error', e.message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final List<Map<String, dynamic>> users = [];
    try {
      final usersSnapshot = await firestore.collection('users').get();

      //Getting all the users and adding them to the list
      if (usersSnapshot.docs.isNotEmpty) {
        for (var element in usersSnapshot.docs) {
          users.add(element.data());
        }
      }
      return users;
    } on FirebaseException catch (e) {
      FirestoreDbFailure.code(e.code);
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }

    throw UnimplementedError();
  }

  @override
  Future<void> addMembersToRoom(
      String groupId, List<GroupMembers> members) async {
    //adding the user to the group members list of the group with the given group id
    try {
      firestore.collection('groups').doc(groupId).update({
        'groupMembers':
            FieldValue.arrayUnion(members.map((e) => e.toMap()).toList()),
      });
      //updating the user's group list with the group id
      for (var member in members) {
        firestore
            .collection('users')
            .where('email', isEqualTo: member.email)
            .get()
            .then((value) => {
                  firestore
                      .collection('users')
                      .doc(value.docs.first.id)
                      .update({
                    'groups': FieldValue.arrayUnion([groupId]),
                  })
                });
      }
    } on FirestoreDbFailure catch (e) {
      Get.snackbar('Error adding Member in DB', e.message,
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error adding Member in DB', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Future<void> removeMembersFromRoom(
      String groupId, List<GroupMembers> members) async {
    //removing the user from the group members list of the group with the given group id
    try {
      firestore.collection('groups').doc(groupId).update({
        'groupMembers':
            FieldValue.arrayRemove(members.map((e) => e.toMap()).toList()),
      });
      //updating the user's group list with the group id
      for (var member in members) {
        firestore
            .collection('users')
            .where('email', isEqualTo: member.email)
            .get()
            .then((value) => {
                  firestore
                      .collection('users')
                      .doc(value.docs.first.id)
                      .update({
                    'groups': FieldValue.arrayRemove([groupId]),
                  })
                });
      }
    } on FirestoreDbFailure catch (e) {
      Get.snackbar('Error removing Member in DB', e.message,
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error removing Member in DB', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Future<void> leaveRoom(String groupId, String userEmail) async {
    try {
      //remove the user from the group members list of the group with the given group id

      //get the member of group member whose email is equal to the user email
      firestore.collection('groups').doc(groupId).get().then((value) => {
            firestore.collection('groups').doc(groupId).update({
              'groupMembers': FieldValue.arrayRemove([
                value
                    .data()!['groupMembers']
                    .firstWhere((element) => element['email'] == userEmail)
              ])
            })
          });
      print('removing of member done');
      //removing the group id from the user's group list
      firestore
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get()
          .then((value) => {
                firestore.collection('users').doc(value.docs.first.id).update({
                  'groups': FieldValue.arrayRemove([groupId])
                })
              });
      print('removing of group id from user done');
      Get.snackbar('Group Left', 'You have left  the group',
          snackPosition: SnackPosition.BOTTOM);
    } on FirestoreDbFailure catch (e) {
      print(e.message);
      Get.snackbar('Error removing Member in DB', e.message,
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      print(e.toString());
      Get.snackbar('Error removing Member in DB', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  //----------------------Group Messages sepcific operations----------------------//

  Stream<QuerySnapshot> getMessagesStream(String groupId, String channelId) {
    //getting the messages of the group channel with the given group id and channel id
    try {
      //
      return firestore
          .collection('groups')
          .doc(groupId)
          .collection('channels')
          .doc(channelId)
          .collection('messages')
          //getting the messages in descending order of timestamp
          .orderBy('timestamp', descending: true) // todo to add limit
          .snapshots(
              //getting the messages with the metadata changes i.e. when a new message is added or deleted
              includeMetadataChanges: true);
    } on FirebaseException catch (e) {
      FirestoreDbFailure.code(e.code);
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
    throw UnimplementedError();
  }

  // Future<List<Map<String, dynamic>>> getMessages(groupId) async {
  //   final List<Map<String, dynamic>> messages = [];
  //   try {
  //     final messagesSnapshot = await firestore
  //         .collection('groups')
  //         .doc(groupId)
  //         .collection('messages')
  //         .orderBy('timestamp', descending: true)
  //         .get();

  //     if (messagesSnapshot.docs.isNotEmpty) {
  //       for (var element in messagesSnapshot.docs) {
  //         messages.add(element.data());
  //       }
  //     }
  //     return messages;
  //   } on FirebaseException catch (e) {
  //     FirestoreDbFailure.code(e.code);
  //     Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
  //   } catch (e) {
  //     Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
  //   }

  //   return messages;
  // }

  Future<void> sendMessages(
      String groupId, String channelId, Message msg) async {
    try {
      //creating a Unique id for the message
      final messageId = firestore
          .collection('groups')
          .doc(groupId)
          .collection('channels')
          .doc(channelId)
          .collection('messages')
          .doc()
          .id;
      //creating a message document with the message id and adding the message data to it
      await firestore
          .collection('groups')
          .doc(groupId)
          .collection('channels')
          .doc(channelId)
          .collection('messages')
          .doc(messageId)
          .set({
        'messageId': messageId,
        'senderId':
            AuthenticationRepositoryImpl.instance.currentUser.value.userID,
        'messageText': msg.messageText,
        'timestamp': DateTime.now().toIso8601String(),
        'senderEmail':
            AuthenticationRepositoryImpl.instance.currentUser.value.email,
        'senderName':
            AuthenticationRepositoryImpl.instance.currentUser.value.fullName,
        'senderImg': AuthenticationRepositoryImpl
            .instance.currentUser.value.profilePicture,
      });
    } on FirebaseException catch (e) {
      FirestoreDbFailure.code(e.code);
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Future<void> createChannel(String groupId, Channel channel) async {}

  @override
  Future<List<Message>> getChatsOfGroup(String groupId, String channelId) {
    // TODO: implement getChatsOfGroup
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> getChannelOfGroup(String groupId) async {
    final List<Map<String, dynamic>> channels = [];
    try {
      final channelsSnapshot = await firestore
          .collection('groups')
          .doc(groupId)
          .collection('channels')
          .get();

      if (channelsSnapshot.docs.isNotEmpty) {
        for (var element in channelsSnapshot.docs) {
          print(element.data());
          channels.add(element.data());
        }
      }
      return Future.value(channels);
    } on FirebaseException catch (e) {
      FirestoreDbFailure.code(e.code);
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      print(e.toString());
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
    return Future.value(channels);
  }

  CollectionReference<Map<String, dynamic>>
      getMessagesOfGroupsChannelCollection(String groupId, String channelId) {
    try {
      return firestore
          .collection('groups')
          .doc(groupId)
          .collection('channels')
          .doc(channelId)
          .collection('messages');
    } on FirebaseException catch (e) {
      FirestoreDbFailure.code(e.code);
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      print(e.toString());
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
    throw UnimplementedError();
  }

  // todo to add this function in the group repository
  Future<List<Map<String, dynamic>>> getMessagesOfGroupsChannel(
      String groupId, String channelId) async {
    //getting the messages of the group channel with the given group id and channel id
    final List<Map<String, dynamic>> messages = [];
    try {
      final messagesSnapshot = await firestore
          .collection('groups')
          .doc(groupId)
          .collection('channels')
          .doc(channelId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .get();
      print(
          'messagesSnapshot.docs.isNotEmpty ${messagesSnapshot.docs.isNotEmpty}');
      if (messagesSnapshot.docs.isNotEmpty) {
        for (var element in messagesSnapshot.docs) {
          messages.add(element.data());
          print('--------------messages: ${element.data()}}---------------');
        }
      }
      return messages;
    } on FirebaseException catch (e) {
      FirestoreDbFailure.code(e.code);
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
    return messages;
  }

  @override
  Future<void> deleteMessage(
      String groupId, String channelId, String messageId) async {
    //deleting the message with the given message id from the group channel with the given group id and channel id
    try {
      await firestore
          .collection('groups')
          .doc(groupId)
          .collection('channels')
          .doc(channelId)
          .collection('messages')
          .doc(messageId)
          .delete();
    } on FirebaseException catch (e) {
      FirestoreDbFailure.code(e.code);
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Future<void> sendMessage(String groupId, String channelId, Message message) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }

  // @override
  // Future<Challenge> fetchChallenge(String challengeId) {

  //   //fetching challenges from the firebase
  //       DocumentSnapshot challengeDoc =
  //       await FirebaseFirestore.instance.collection('challenges').doc(challengeId).get();

  //   // Deciphering the Challenge data
  //   Map<String, dynamic> challengeData = challengeDoc.data() as Map<String, dynamic>;

  //   // Now populating the challenge
  //   final chanllenge

  //   // For the Participants subcollection
  //   QuerySnapshot participantsQuery = await FirebaseFirestore.instance
  //       .collection('challenges')
  //       .doc(challengeId)
  //       .collection('participants')
  //       .get();

  //   // Deciphering participant data
  //   List<QueryDocumentSnapshot> participantDocs = participantsQuery.docs;

  //   for (var participantDoc in participantDocs) {
  //     // Accessing participant data
  //     Map<String, dynamic> participantData = participantDoc.data() as Map<String, dynamic>;

  //     String userId = participantData['userId'];
  //     String displayName = participantData['displayName'];
  //     // Access other participant fields...
  //   }
  // } catch (e) {
  //   print('Error fetching challenge data: $e');
  // }

  //   // TODO: implement fetchChallenge
  //   throw UnimplementedError();
  // }

  @override
  Future<List<Participant>> fetchParticipant(String challengId) {
    // TODO: implement fetchParticipant
    throw UnimplementedError();
  }

  @override
  Future<void> postChallengeAndParticipants(
      Challenge challenge, List<Participant> participants) {
    // TODO: implement postChallengeAndParticipants
    throw UnimplementedError();
  }
  
  @override
  Future<Challenge> fetchChallenge(String challengeId) {
    // TODO: implement fetchChallenge
    throw UnimplementedError();
  }
}
