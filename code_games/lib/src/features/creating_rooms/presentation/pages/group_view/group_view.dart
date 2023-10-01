import 'package:code_games/src/features/creating_rooms/presentation/pages/group_view/widgets/group_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:code_games/src/features/creating_rooms/domain/entity/group_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

class GroupView extends StatefulWidget {
  const GroupView({Key? key, required this.group}) : super(key: key);

  final GroupEntity group;

  @override
  _GroupViewState createState() => _GroupViewState();
}

class _GroupViewState extends State<GroupView> {
  final TextEditingController _messageController = TextEditingController();
  List<String> _messages = [
    'Hello, how are you?',
    'I\'m good, thanks! How about you?',
    'I\'m doing great!',
    'What are you up to?',
    'Just working on some code.',
    'Nice! Keep it up!'
  ];

  void _sendMessage(String message) {
    if (message.isNotEmpty) {
      setState(() {
        _messages.add(message);
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
            Get.to(() => GroupDetailView(group: widget.group),
                transition: Transition.rightToLeft);
          },
          title: Text(widget.group.groupName),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(widget.group.groupImg),
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
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        _messages[index],
                        style: const TextStyle(color: Colors.white),
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
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
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
