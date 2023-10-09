import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_games/src/features/creating_rooms/presentation/pages/group_view/group_detail_view.dart';
import 'package:code_games/src/features/creating_rooms/presentation/pages/group_view/widgets/channel_side_darwer.dart';
import 'package:flutter/material.dart';
import 'package:code_games/src/features/creating_rooms/domain/entity/group_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

import '../../stateMangement/group_controller.dart';

class GroupChatView extends StatefulWidget {
  const GroupChatView({Key? key, required this.group}) : super(key: key);

  final GroupEntity group;

  @override
  createState() => _GroupChatViewState();
}

class _GroupChatViewState extends State<GroupChatView> {
  final controller = Get.find<GroupController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero, () {
      controller.getChannelList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ChannelSideDrawer(
        channels: controller.channelsList,
      ),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: ListTile(
          onTap: () {
            Get.to(() => const GroupDetailView(),
                transition: Transition.rightToLeft);
          },
          title: Text(controller.userRooms
              .value[controller.currentlySelectedGroupIndex.value].groupName),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(controller.userRooms
                .value[controller.currentlySelectedGroupIndex.value].groupImg),
          ),
        ),
        //leading Icon to open the drawer
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.menu),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              //Pop up menu to show the options to leave the group and other options
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Options'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          onTap: () {
                            controller.leaveGroup();
                            Navigator.pop(context);
                          },
                          title: const Text('Leave Group'),
                          leading: const Icon(Icons.exit_to_app),
                        ),
                        ListTile(
                          onTap: () {
                            //Delete the group
                            Navigator.pop(context);
                          },
                          title: const Text('Delete Group'),
                          leading: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Obx(
            () => controller.isLoading.value == false
                ? controller.groupMessages.isNotEmpty
                    ? Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('groups')
                              .doc(controller
                                  .userRooms
                                  .value[controller
                                      .currentlySelectedGroupIndex.value]
                                  .groupId)
                              .collection('channels')
                              .doc(controller
                                  .channelsList[controller
                                      .currentlySelectedChannelIndex.value]
                                  .channelId)
                              .collection('messages')
                              .orderBy('timeStamp', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.active) {
                              if (snapshot.hasData) {
                                var messageList =
                                    controller.getMessages(snapshot);
                                for (var message in messageList) {
                                  print('Inside for in chat View');
                                  print(message);
                                }
                                return ListView.builder(
                                  itemCount: messageList.length,
                                  itemBuilder: (context, index) {
                                    bool isUser = messageList[index].senderId ==
                                        controller.userId.value;
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: isUser
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: Container(
                                          padding: const EdgeInsets.all(12.0),
                                          decoration: BoxDecoration(
                                            color: isUser
                                                ? Colors.blue
                                                : Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Text(
                                            messageList[index].messageText,
                                            style: TextStyle(
                                                color: isUser
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text("Error: ${snapshot.error}"));
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          },
                        ),
                      )
                    : const Center(
                        child: Text("No messages to Show"),
                      )
                : const Center(child: CircularProgressIndicator()),
          ),
          controller.groupMessages.isEmpty ? const Spacer() : Container(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.0),
                      color: Colors.grey[200],
                    ),
                    child: TextField(
                      controller: controller.messageController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type your message...',
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => controller.sendMessage(),
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
