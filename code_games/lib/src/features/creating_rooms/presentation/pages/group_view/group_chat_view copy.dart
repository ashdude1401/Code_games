import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:code_games/src/features/creating_rooms/domain/entity/group_entity.dart';
// import 'package:code_games/src/features/creating_rooms/domain/entity/group_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../auth/data/repository/authentication_repository_impl.dart';

class GroupChatViewNew extends StatefulWidget {
  const GroupChatViewNew({super.key, required this.groupId});

  final String groupId;
  // final String channelId;

  // final  List<Channel> channels;

  @override
  State<GroupChatViewNew> createState() => _GroupChatViewNewState();
}

class _GroupChatViewNewState extends State<GroupChatViewNew> {
  final userController = Get.find<AuthenticationRepositoryImpl>();

  final messageTextController = TextEditingController();

  final firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot<Map<String, dynamic>>> _msgStream;

  late List<Channel> channels;

  @override
  void initState() {
    super.initState();
    channels = [];

    _msgStream = Stream.empty();

    _intialiseStream();
  }

  Future<void> _intialiseStream() async {
    final channelRef = firestore
        .collection('groups')
        .doc(widget.groupId)
        .collection('channels');

    final channelSnapshot = await channelRef.get();

    channels =
        channelSnapshot.docs.map((e) => Channel.fromMap(e.data())).toList();

    _msgStream = firestore
        .collection('groups')
        .doc(widget.groupId)
        .collection('channels')
        .doc(channels[0].channelId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots(includeMetadataChanges: true);

    setState(() {});
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Chat'),
      ),
      body: channels.isNotEmpty
          ? StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _msgStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading');
                }

                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    final message = Message.fromMap(data);
                    return ListTile(
                      title: Text(message.messageText),
                      subtitle: Text(message.senderId),
                    );
                  }).toList(),
                );
              },
            )
          : const Center(
              child: Text('No channels found'),
            ),
      //sending messages button and textfield
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: messageTextController,
                decoration: const InputDecoration(
                  hintText: 'Enter a message',
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () async {
                // await sendMessage(messageTextController.text);
                messageTextController.clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}
