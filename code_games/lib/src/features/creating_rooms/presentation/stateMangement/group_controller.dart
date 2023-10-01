import 'package:code_games/src/features/creating_rooms/data/repository/group_repository_impl.dart';
import 'package:code_games/src/features/creating_rooms/domain/entity/group_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../auth/data/models/user_modal.dart';
import '../../../auth/data/repository/authentication_repository_impl.dart';

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
    // TODO: implement onClose
    super.onClose();
  }

  @override
  void onReady() {
    getUserRooms();
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

  void createGroup() async {
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
        groupImg: groupImg.isEmpty
            ? "https://images.unsplash.com/photo-1593085512500-5d55148d6f0d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1780&q=80"
            : groupImg,
        challengeList: [],
        groupMembers: groupMembers,
        groupId: '',
        admins: admins,
        createdBy: userController.email.value);

    print("----------New Group-------------------${newGroup.groupName}");

    // Call the createRoom method from the repository
    await controller.createRoom(newGroup);
    groupName.clear();
    groupDescription.clear();
    groupImg = "";
    challengeList.clear();
    groupMembers.clear();
    admins.clear();
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
    isLoading.value = false;
    // Print the userRoom names
    for (int i = 0; i < userRooms.value.length; i++) {
      print(
          "----------userRoom-------------------${userRooms.value[i].groupName}");
    }

    print(
        "----------userRoom Length-------------------${userRoomsList.length}");
  }

  //-----------------------All User Specific -------------

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
}
