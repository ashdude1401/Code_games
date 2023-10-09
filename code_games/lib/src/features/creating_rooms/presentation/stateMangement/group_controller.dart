import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_games/src/features/creating_rooms/data/repository/group_repository_impl.dart';
import 'package:code_games/src/features/creating_rooms/domain/entity/group_entity.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  Rx<List<GroupEntity>> userRooms = Rx<List<GroupEntity>>([]);

  final groupName = TextEditingController();
  final groupDescription = TextEditingController();
  final challengeAmount = TextEditingController();
  final challengeParameters = TextEditingController();
  String groupImg = "";
  final challengeList = [];
  final List<GroupMembers> groupMembers = [];
  final List<String> admins = [];
  final List<Channel> channelsList = [];
  final currentlySelectedChannelIndex = 0.obs;

  @override
  void onClose() {
    groupName.dispose();
    groupDescription.dispose();
    challengeAmount.dispose();
    challengeParameters.dispose();
    messageController.dispose();
    // streamController.close();

    super.onClose();
  }

  @override
  void onReady() {
    // getUserRooms();
    getAllusers();
    userId.value = userController.currentUser.value.userID;
    // getChannelList();

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

    //creating three default channels in firebase general , announcements and Challenges

    // Create a Group object with the entered data
    final newGroup = GroupEntity(
        groupName: groupName.text,
        groupDescription: groupDescription.text,
        groupImg: profilePicture,
        groupMembers: groupMembers,
        admins: admins,
        createdBy: userController.email.value,
        challengesRefferenceId: [],
        channelReferenceId: [],
        groupId: '');

    print("----------New Group-------------------${newGroup.groupName}");

    //general channel
    Channel generalChannel = Channel(
        channelId: '',
        channelName: 'General',
        channelDescription: 'For General discussion',
        channelImg:
            'https://plus.unsplash.com/premium_photo-1681488159219-e0f0f2542424?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1974&q=80',
        messagesReferenceId: '');

    //announcements channel
    Channel announcementsChannel = Channel(
        channelId: '',
        channelName: 'Announcements',
        channelDescription: 'For Announcements',
        channelImg:
            'https://images.unsplash.com/photo-1529335764857-3f1164d1cb24?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1889&q=80',
        messagesReferenceId: '');

    //challenges channel

    Channel challengesChannel = Channel(
        channelId: '',
        channelName: 'Challenges',
        channelDescription: 'For Challenges',
        channelImg:
            'https://images.unsplash.com/photo-1606663889134-b1dedb5ed8b7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1887&q=80',
        messagesReferenceId: '');

    List<Channel> channels = [
      generalChannel,
      announcementsChannel,
      challengesChannel
    ];

    // Call the createRoom method from the repository
    await controller.createRoom(newGroup, channels);

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

  Future<void> getChannelList() async {
    try {
      isLoading.value = true;
      List<Map<String, dynamic>> channelList =
          await controller.getChannelOfGroup(
              userRooms.value[currentlySelectedGroupIndex.value].groupId);
      channelsList.clear();
      for (var element in channelList) {
        channelsList.add(Channel.fromMap(element));
      }
      isLoading.value = false;
    } catch (e) {
      print(e.toString());
    }
  }

  //-----------------------All User Specific -------------
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
        isLoading.value = false;

        return;
      }
    }

    if (selectedUsers.isEmpty) {
      isLoading.value = false;
      Get.snackbar('Error', 'No users selected',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Add the selected users to the group members list in the database
    await controller.addMembersToRoom(
        userRooms.value[currentlySelectedGroupIndex.value].groupId,
        selectedUsers
            .map((user) => GroupMembers(
                userName: user.fullName,
                userImg: user.profilePicture,
                userScore: '0',
                userRank: '0',
                email: user.email))
            .toList());

    // Add the selected users to the group members list in the userRooms list
    userRooms.value[currentlySelectedGroupIndex.value].groupMembers.addAll(
        selectedUsers
            .map((user) => GroupMembers(
                userName: user.fullName,
                userImg: user.profilePicture,
                userScore: '0',
                userRank: '0',
                email: user.email))
            .toList());
    // Update the userRooms list
    isLoading.value = false;
    getUserRooms();
    Get.back();
    print("----------userRoom-------------------updated");
    Get.snackbar('Members Added', 'Members added successfully',
        snackPosition: SnackPosition.BOTTOM);
    selectedUsers.clear();
  }

  //-------------------Leaving Group-----------------
  Future<void> leaveGroup() async {
    isLoading.value = true;
    await controller.leaveRoom(
        userRooms.value[currentlySelectedGroupIndex.value].groupId,
        userController.email.value);
    // Update the userRooms list
    getUserRooms();
    isLoading.value = false;
    Get.back();
  }

//-----------------chat related---------------------------------------------------------------
  // get all message  returning
  List<Message> groupMessages = [];

  final TextEditingController messageController = TextEditingController();
  final userId = "".obs;

  // StreamController<QuerySnapshot> streamController =
  //     StreamController<QuerySnapshot>();

  // Future<void> getMessageStream() async {
  //   isLoading.value = true;
  //   await streamController.addStream(controller.getMessagesStream(
  //       userRooms.value[currentlySelectedGroupIndex.value].groupId));
  //   isLoading.value = false;
  // }

  List<Message> getMessages(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    print('Inside Get Messages');
    final messages = snapshot.data!.docs;
    List<Message> messagesList = [];
    for (var message in messages) {
      print(message);
      messagesList.add(Message.fromMap(message.data() as Map<String, dynamic>));
    }
    return messagesList;
  }

  Future<void> sendMessage() async {
    print('inside send message');
    if (messageController.text.isNotEmpty) {
      print('message is not empty');
      await controller.sendMessages(
          userRooms.value[currentlySelectedGroupIndex.value].groupId,
          channelsList[currentlySelectedChannelIndex.value].channelId,
          Message(
              messageText: messageController.text,
              senderId: userController.currentUser.value.userID,
              timestamp: DateTime.now()));
      print("message sent");
      messageController.clear();
      // getMessages();
    }
  }
}

// function to get id for firebase collections 

