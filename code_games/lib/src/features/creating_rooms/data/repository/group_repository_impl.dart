import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_games/src/features/creating_rooms/data/repository/exception/firestore_expception.dart';
import 'package:code_games/src/features/core/presentation/pages/home/home_view/home_view.dart';

import 'package:get/get.dart';

import '../../domain/entity/group_entity.dart';
import '../../domain/repository/Group_repository.dart';

class GroupRepositoryImpl extends GetxController implements GroupRepository {
  //Intializing firestore instance to perform CRUD operations on the database

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // @override
  // Future<void> createRoom(GroupEntity group) async {
  //   //Creating a new document in the firestore collection with the group name as the document id
  //   try {
  //     firestore.collection('groups').add(group.toMap()).then((value) async {
  //       //Updating the group id of the group created
  //       await firestore.collection('groups').doc(value.id).update({
  //         'groupId': value.id,
  //       }).then((value) {
  //         //Updating the list of groups created by the user(seraching for the user with the email id and then updating the list of groups created by the user)
  //         firestore
  //             .collection('users')
  //             .where('email', isEqualTo: group.createdBy)
  //             .get()
  //             .then((value) {
  //           if (value.docs.isNotEmpty) {
  //             for (var element in value.docs) {
  //               firestore.collection('users').doc(element.id).update({
  //                 'groups': FieldValue.arrayUnion([group.groupName])
  //               });
  //             }
  //           }
  //         }).then((value) {
  //           Get.back();
  //           Get.snackbar('Success', 'Room Created Successfully',
  //               snackPosition: SnackPosition.BOTTOM);
  //         });
  //       });
  //     });
  //   } on FirebaseException catch (e) {
  //     FirestoreDbFailure.code(e.code);
  //     Get.snackbar('Error', e.toString());
  //   } catch (e) {
  //     Get.snackbar('Error', e.toString());
  //   }
  // }

  @override
  Future<void> createRoom(GroupEntity group) async {
    try {
      // Creating a new document in the 'groups' collection and getting the document reference
      DocumentReference groupDocRef =
          await firestore.collection('groups').add(group.toMap());

      // Updating the group id of the group created
      await groupDocRef.update({'groupId': groupDocRef.id});

      // Updating the list of groups created by the user
      QuerySnapshot userSnapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: group.createdBy)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        String userId = userSnapshot.docs.first.id;
        await firestore.collection('users').doc(userId).update({
          'groups': FieldValue.arrayUnion([group.groupName]),
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
          // Getting the list of groups created by the user or joined by the user
          var groups = element['groups'] ??
              <String>[]; // Use an empty list if 'groups' is null

          if (groups.isNotEmpty) {
            var groupsSnapshot = await firestore
                .collection('groups')
                .where('groupName', whereIn: element['groups'])
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
  Future<void> updateRoom(GroupEntity newGroup, GroupEntity oldGroup) {
    // TODO: implement updateRoom
    throw UnimplementedError();
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
}
