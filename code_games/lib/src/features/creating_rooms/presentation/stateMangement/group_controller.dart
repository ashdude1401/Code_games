import 'dart:developer';
import 'dart:io';

import 'package:code_games/src/features/creating_rooms/data/repository/group_repository_impl.dart';
import 'package:code_games/src/features/creating_rooms/domain/entity/group_entity.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../auth/data/models/user_modal.dart';
import '../../../auth/data/repository/authentication_repository_impl.dart';
import '../pages/group_view/group_detail_view.dart';

enum Method { camera, gallery }

class GroupController extends GetxController {
  final controller = Get.put(GroupRepositoryImpl());
  final userController = Get.find<AuthenticationRepositoryImpl>();

  final isLoading = false.obs;

  final groupName = TextEditingController();
  final groupDescription = TextEditingController();
  final challengeAmount = TextEditingController();
  final challengeParameters = TextEditingController();
  String groupImg = "";
  final challengeList = [];
  final List<GroupMembers> groupMembers = [];
  final List<String> admins = [];
  Rx<List<GroupEntity>> userRooms = Rx<List<GroupEntity>>([]);

  @override
  void onClose() {
    groupName.dispose();
    groupDescription.dispose();
    challengeAmount.dispose();
    challengeParameters.dispose();
    super.onClose();
  }

  @override
  void onReady() {
    // getUserRooms();
    getAllusers();

    super.onReady();
  }

  void pickImage(Method method) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
        source: method == Method.gallery
            ? ImageSource.gallery
            : ImageSource.camera);
    if (image != null) {
      groupImg = image.path;
    }
  }

  void createGroup(XFile? img) async {
    isLoading.value = true;
    String profilePicture =
        "https://images.unsplash.com/photo-1593085512500-5d55148d6f0d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1780&q=80";

    if (img != null) {
      try {
        final ref =
            FirebaseStorage.instance.ref().child('groupImages/$groupName');
        await ref.putFile(File(img.path));
        profilePicture = await ref.getDownloadURL();
      } catch (e) {
        isLoading.value = false;
        Get.snackbar('Error', 'Failed to upload profile picture',
            snackPosition: SnackPosition.BOTTOM);
        log(e.toString());
        return;
      }
    }

    groupMembers.add(GroupMembers(
        userName: userController.userName.value,
        userImg: userController.profilePicture.value,
        userScore: '0',
        userRank: '0',
        email: userController.email.value));
    admins.add(userController.email.value);
    // Create a Group object with the entered data
    final newGroup = GroupEntity(
        groupName: groupName.text,
        groupDescription: groupDescription.text,
        groupImg: profilePicture,
        challengeList: [],
        groupMembers: groupMembers,
        groupId: '',
        admins: admins,
        createdBy: userController.email.value);

    print("----------New Group-------------------${newGroup.groupName}");

    // Call the createRoom method from the repository
    await controller.createRoom(newGroup);
    isLoading.value = false;

    groupName.clear();
    groupDescription.clear();
    groupImg = "";
    challengeList.clear();
    groupMembers.clear();
    admins.clear();
    challengeAmount.clear();
    challengeParameters.clear();
  }

  Future<void> getUserRooms() async {
    isLoading.value = true;
    List<Map<String, dynamic>> userRoomsList =
        await controller.getRoomsOfUser(userController.email.value);

    // Clear the current userRooms list before adding new items
    userRooms.value.clear();

    // Converting the list of maps to list of GroupEntity and adding it to the userRooms list
    for (var element in userRoomsList) {
      userRooms.value.add(GroupEntity.fromMap(element));
    }

    // Print the userRoom names
    for (int i = 0; i < userRooms.value.length; i++) {
      print(
          "----------userRoom-------------------${userRooms.value[i].groupName}");
    }

    print(
        "----------userRoom Length-------------------${userRoomsList.length}");
    isLoading.value = false;
  }

  //-----------------------All User Specific -------------

  //to-do to add these as abstract methods in the GroupRepository

  final allUsers = Rx<List<UserEntity>>([]);
  Future<void> getAllusers() async {
    allUsers.value.clear();
    try {
      isLoading.value = true;
      final users = await controller.getAllUsers();
      allUsers.value = users.map((user) => UserEntity.fromMap(user)).toList();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print("Error: $e");
    }
  }

  //Update CurrentUser Details

  void updateCurrentUserDetails(String name, String bio, XFile? img) async {
    try {
      isLoading.value = true;
      await userController.updateUserDetails(name, bio, img);
      isLoading.value = false;
      Get.snackbar('Success', 'User Details Updated',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
      print("Error: $e");
    }
  }

  //-------------------Adding Members to Group-----------------

  final RxList<UserEntity> filteredUsers = RxList<UserEntity>([]);
  final RxList<UserEntity> selectedUsers = RxList<UserEntity>([]);

  final currentlySelectedGroupIndex = 0.obs;
  void filterUsers(String query) {
    // Filter users based on the query and update filteredUsers list excluding the current user and the users already added to the group
    filteredUsers.value = allUsers.value
        .where((user) =>
            user.fullName.toLowerCase().contains(query.toLowerCase()) &&
            user.email != userController.email.value &&
            !userRooms.value[currentlySelectedGroupIndex.value].groupMembers
                .any((element) => element.email == user.email))
        .toList();
  }

  void selectUser(UserEntity user) {
    // Add the selected user to the selectedUsers list
    selectedUsers.add(user);
  }

  bool isSelected(UserEntity user) {
    return selectedUsers.contains(user);
  }

  void deselectUser(UserEntity user) {
    selectedUsers.remove(user);
  }

  Future<void> addMembers() async {
    isLoading.value = true;

    // Check if the selectedUsers list is empty
    for (var user in selectedUsers) {
      if (userRooms.value[currentlySelectedGroupIndex.value].groupMembers
          .any((element) => element.email == user.email)) {
        Get.snackbar('Error', '${user.fullName} already exists in the group',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }
    }

    //adding the selected users to the group members list
    userRooms.value[currentlySelectedGroupIndex.value].groupMembers.addAll(
      selectedUsers.map(
        (user) => GroupMembers(
            userName: user.fullName,
            userImg: user.profilePicture,
            userScore: '0',
            userRank: '0',
            email: user.email),
      ),
    );
    print(
        "----------userRoom-------------------${userRooms.value[currentlySelectedGroupIndex.value].groupMembers.length}");

    //Also update each user's group list with the group name
    for (var user in selectedUsers) {
      List<String> groupNames = [];

      groupNames
          .add(userRooms.value[currentlySelectedGroupIndex.value].groupName);
      await userController.addGroupToUserGroups(groupNames, user);

      for (var groupName in user.groups) {
        print("----------userRoom-------------------${groupName}");
      }
      print("updated user ${user.email}---------------");
    }

    print(
        "-------------------updating user group list finished ---------------");
    // Update the group in the database
    await controller
        .updateRoom(userRooms.value[currentlySelectedGroupIndex.value]);


    print("----------userRoom-------------------updated");
    Get.snackbar('Members Added', 'Members added successfully',
        snackPosition: SnackPosition.BOTTOM);

    // Clear the selectedUsers list
    selectedUsers.clear();
    Get.back();  
    isLoading.value = false;
  }
}
