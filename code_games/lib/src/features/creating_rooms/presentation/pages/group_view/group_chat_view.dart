import 'package:code_games/src/features/auth/data/repository/authentication_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../domain/entity/group_entity.dart';
import '../../stateMangement/group_controller.dart';
import 'group_detail_view.dart';
import 'widgets/channel_side_darwer.dart';

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
    super.initState();
    Future.delayed(Duration.zero, () {
      controller.getChannelList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ChannelSideDrawer(channels: controller.channelsList),
      appBar: AppBar(
        centerTitle: true,
        title: GestureDetector(
          onTap: () {
            Get.to(() => const GroupDetailView(),
                transition: Transition.rightToLeft);
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  CachedNetworkImageProvider(widget.group.groupImg),
            ),
            title: Text(widget.group.groupName),
            // subtitle: Obx(
            //         () => Text(controller
            //             .channelsList[
            //                 controller.currentlySelectedChannelIndex.value]
            //             .channelName),
            //       )
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.menu),
          ),
        ),
        //showing the current channel name at bottom of the appbar
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20.0),
          child: Obx(
            () => controller.isLoading == false
                ? Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    color: Colors.deepPurpleAccent[100],
                    child: Text(
                        controller
                            .channelsList[
                                controller.currentlySelectedChannelIndex.value]
                            .channelName,
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                  )
                : const Text("Loading..."),
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {
              // Show options to leave the group and other actions
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
                            // Delete the group
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
          Expanded(
            child: Obx(
              () => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : controller.messagesList.isNotEmpty
                      ? ListView.builder(
                          itemCount: controller.messagesList.length,
                          controller: controller.scrollController,
                          itemBuilder: (context, index) {
                            Message message = controller.messagesList[index];
                            bool isUser = message.senderEmail ==
                                AuthenticationRepositoryImpl
                                    .instance.currentUser.value.email;
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: isUser
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: isUser
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: isUser
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                      children: [
                                        if (isUser == false)
                                          CircleAvatar(
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                    message.senderImg),
                                            radius: 16,
                                          ),
                                        if (isUser == false)
                                          const SizedBox(width: 8),
                                        if (isUser == false)
                                          Text(
                                            message.senderName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                      ],
                                    ),
                                    // Container(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   decoration: BoxDecoration(
                                    //     color: isUser
                                    //         ? Colors.blue
                                    //         : Colors.grey[300],
                                    //     borderRadius:
                                    //         BorderRadius.circular(8.0),
                                    //   ),
                                    //   child: ListTile(
                                    //     title: isUser
                                    //         ? Text(
                                    //             message.messageText,
                                    //             style: TextStyle(
                                    //                 color: isUser
                                    //                     ? Colors.white
                                    //                     : Colors.black),
                                    //           )
                                    //         : null,
                                    //     subtitle: Text(
                                    //       //time and date of the message
                                    //       "${message.timestamp.hour}:${message.timestamp.minute} on ${message.timestamp.day}/${message.timestamp.month}/${message.timestamp.year}  ",
                                    //       style: TextStyle(
                                    //           color: isUser
                                    //               ? Colors.white60
                                    //               : Colors.grey[600]),
                                    //     ),
                                    //   ),
                                    // ),
                                    GestureDetector(
                                      onLongPress: () {
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
                                                      // controller
                                                      //     .deleteMessage(
                                                      //         message);
                                                      Navigator.pop(context);
                                                    },
                                                    title: const Text(
                                                        'Delete Message'),
                                                    leading: const Icon(
                                                        Icons.delete),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: isUser
                                              ? Colors.blue
                                              : Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: isUser
                                              ? CrossAxisAlignment.end
                                              : CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              message.messageText,
                                              style: TextStyle(
                                                  color: isUser
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "${message.timestamp.hour}:${message.timestamp.minute} on ${message.timestamp.day}/${message.timestamp.month}/${message.timestamp.year}",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: isUser
                                                      ? Colors.white60
                                                      : Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(child: Text("No messages to Show")),
            ),
          ),
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
                  onPressed: () {
                    if (controller.messageController.text.isNotEmpty) {
                      controller.sendMessage();
                      controller.messageController.clear();
                    }
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
      //bottomNavigationBar to to home view , create group view and profile view
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 0,
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.group_add), label: 'Create Group'),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      //   ],
      //   onTap: (index) {
      //     switch (index) {
      //       case 0:
      //         Get.offAllNamed('/home');
      //         break;
      //       case 1:
      //         Get.offAllNamed('/createGroup');
      //         break;
      //       case 2:
      //         Get.offAllNamed('/profile');
      //         break;
      //     }
      //   },
      // ),
    );
  }
}


/**
 * ListView.builder(
                          itemCount: controller.messagesList.length,
                          controller: controller.scrollController,
                          itemBuilder: (context, index) {
                            Message message = controller.messagesList[index];
                            bool isUser =
                                message.senderId == controller.userId.value;
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: isUser
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      if (!isUser)
                                        CircleAvatar(
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                                  message.senderImg),
                                          radius: 16,
                                        ),
                                      if (!isUser) const SizedBox(width: 8),
                                      Text(
                                        message.senderName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: isUser
                                          ? Colors.blue
                                          : Colors.grey[300],
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          message.messageText,
                                          style: TextStyle(
                                              color: isUser
                                                  ? Colors.white
                                                  : Colors.black),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${message.timestamp.hour}:${message.timestamp.minute}",
                                          style: TextStyle(
                                              color: isUser
                                                  ? Colors.white
                                                  : Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
 */