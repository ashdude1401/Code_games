import 'package:code_games/src/features/creating_rooms/presentation/pages/group_view/group_detail_view.dart';
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

  final TextEditingController _messageController = TextEditingController();
  List<Map<String, String>> _messages = [
    {'message': 'Hello, how are you?', 'sender': 'user'},
    {'message': 'I\'m good, thanks! How about you?', 'sender': 'other'},
    {'message': 'I\'m doing great!', 'sender': 'other'},
    {'message': 'What are you up to?', 'sender': 'other'},
    {'message': 'Just working on some code.', 'sender': 'user'},
    {'message': 'Nice! Keep it up!', 'sender': 'other'}
  ];

  void _sendMessage(String message) {
    if (message.isNotEmpty) {
      setState(() {
        _messages.add({'message': message, 'sender': 'user'});
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: ListTile(
          onTap: () {
            Get.to(
                () => GroupDetailView(
                    ),
                transition: Transition.rightToLeft);
          },
          title: Text(controller.userRooms
              .value[controller.currentlySelectedGroupIndex.value].groupName),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(controller.userRooms
                .value[controller.currentlySelectedGroupIndex.value].groupImg),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                bool isUser = _messages[index]['sender'] == 'user';
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        _messages[index]['message']!,
                        style: TextStyle(
                            color: isUser ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                );
              },
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
                      controller: _messageController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type your message...',
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _sendMessage(_messageController.text);
                  },
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
