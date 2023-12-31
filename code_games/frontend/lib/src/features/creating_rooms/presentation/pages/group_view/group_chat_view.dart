import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_games/src/features/auth/data/repository/authentication_repository_impl.dart';
import 'package:code_games/src/features/challenges/presentation/state_mangment/challenge_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../challenges/domain/entity/challenge.dart';
import '../../../../challenges/presentation/pages/create_challenge/create_challlenge_page.dart';
import '../../../domain/entity/group_entity.dart';
import '../../stateMangement/group_controller.dart';
import 'group_detail_view.dart';
import 'widgets/channel_side_darwer.dart';

class GroupChatView extends StatefulWidget {
  const GroupChatView(
      {Key? key,
      required this.groupId,
      required this.channelIndex,
      required this.groupName,
      required this.groupImg})
      : super(key: key);

  final String groupId;
  final int channelIndex;
  final String groupName;
  final String groupImg;

  @override
  createState() => _GroupChatViewState();
}

class _GroupChatViewState extends State<GroupChatView>
    with WidgetsBindingObserver {
  final firestore = FirebaseFirestore.instance;

  final userController = Get.find<AuthenticationRepositoryImpl>();

  final challengeController = Get.put(ChallengeController());
  final controller = Get.find<GroupController>();

  final messageTextController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final GlobalKey<ScrollableState> _scrollableKey = GlobalKey();

  late Stream<QuerySnapshot<Map<String, dynamic>>> _msgStream;
  late List<Channel> channels;
  late List<Challenge> challenges;

  void _scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _goToBottom() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  @override
  void initState() {
    super.initState();
    channels = [];
    challenges = [];

    _msgStream = const Stream.empty();

    // Add the observer to the widget's lifecycle
    WidgetsBinding.instance.addObserver(this);

    _intialiseStream();
    // intialiseChallenges();
  }

  @override
  void dispose() {
    // Remove the observer when the widget is disposed
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    // Called whenever the window metrics change, including when the keyboard opens or closes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Scroll to the bottom of the list when the keyboard opens
      _goToBottom();
    });
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
        .doc(channels[controller.currentlySelectedChannelIndex.value].channelId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots(includeMetadataChanges: true);

    await intialiseChallenges();
    setState(() {});
  }

  Future<void> intialiseChallenges() async {
    print("Initialising challenges");
    challenges = await challengeController.getAllChallenges(widget.groupId);
    print("Challenges lenght: $challenges.length");
    for (var challenge in challenges) {
      print("Challenge: ${challenge.title}");
    }

    setState(() {});
  }

  Future<void> sendMessage(String msg, int index) async {
    final messageText = messageTextController.text;
    final timestamp = DateTime.now();
    final senderId = userController.currentUser.value.userID;
    final senderEmail = userController.currentUser.value.email;
    final senderName = userController.currentUser.value.fullName;
    final senderImg = userController.currentUser.value.profilePicture;

    final channelRef = firestore
        .collection('groups')
        .doc(widget.groupId)
        .collection('channels')
        .doc(channels[controller.currentlySelectedChannelIndex.value].channelId)
        .collection('messages');

    final msgId = channelRef.doc().id;

    final message = Message(
        messageId: msgId,
        senderId: senderId,
        messageText: messageText,
        timestamp: timestamp,
        senderEmail: senderEmail,
        senderName: senderName,
        senderImg: senderImg);

    await channelRef.doc(msgId).set(message.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //setting channel img as background

      drawer: ChannelSideDrawer(
        onTap: _intialiseStream,
        channels: channels,
        challenges: challenges,
        groupId: widget.groupId,
        channelIndex: widget.channelIndex,
      ),

      appBar: AppBar(
        title: GestureDetector(
            onTap: () {
              Get.to(() => const GroupDetailView(),
                  transition: Transition.rightToLeft);
            },
            child: Text(widget.groupName)),
        centerTitle: true,
        actions: [
          //Circular avatar showing the group image
          GestureDetector(
            onTap: () {
              Get.to(() => const GroupDetailView(),
                  transition: Transition.rightToLeft);
            },
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                widget.groupImg,
              ),
            ),
          ),
          const SizedBox(width: 8),
          //add challenge button
          IconButton(
            onPressed: () {
              Get.to(() => CreateChallengePage(
                    groupId: widget.groupId,
                    onChallengeCreated: intialiseChallenges,
                  ));
            },
            icon: const Icon(Icons.add),
          ),
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
                            // intialiseChallenges();
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
        //bottom of appbar showing the current channel name
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20.0),
          child: channels.isEmpty
              ? const Text("Loading")
              : Obx(
                  () => Text(
                      channels[controller.currentlySelectedChannelIndex.value]
                          .channelName),
                ),
        ),
      ),
      body: controller.isLoading.value == false
          ? channels.isNotEmpty
              ? Column(
                  children: [
                    MessagesListFromFirebase(
                      msgStream: _msgStream,
                      scrollController: scrollController,
                    ),
                    //sending messages button and textfield
                    Column(
                      children: [
                        Container(
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
                                  if (messageTextController.text
                                      .trim()
                                      .isEmpty) {
                                    return;
                                  }

                                  await sendMessage(
                                      messageTextController.text.trim(),
                                      controller
                                          .currentlySelectedChannelIndex.value);
                                  messageTextController.clear();

                                  //scrolling List to bottom
                                  scrollController.animateTo(
                                    scrollController.position.maxScrollExtent,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOut,
                                  );
                                },
                              ),
                              IconButton(
                                  onPressed: () {
                                    _goToBottom();
                                  },
                                  //cupertino down arrow
                                  icon: const Icon(
                                    CupertinoIcons.arrow_down_circle_fill,
                                    size: 25,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : const Center(child: Text('No channels found'))
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class MessagesListFromFirebase extends StatelessWidget {
  const MessagesListFromFirebase({
    super.key,
    required Stream<QuerySnapshot<Map<String, dynamic>>> msgStream,
    required this.scrollController,
  }) : _msgStream = msgStream;

  final Stream<QuerySnapshot<Map<String, dynamic>>> _msgStream;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _msgStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final messages = snapshot.data!.docs
              .map((DocumentSnapshot document) =>
                  Message.fromMap(document.data()! as Map<String, dynamic>))
              .toList()
              .reversed
              .toList();

          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Scroll to the bottom of the list whenever new messages are received
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          });

          return ListView.builder(
            controller: scrollController,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              Message message = messages[index];
              bool isUser = message.senderEmail ==
                  AuthenticationRepositoryImpl.instance.currentUser.value.email;
              return MessageBubble(isUser: isUser, message: message);
            },
          );
        },
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.isUser,
    required this.message,
  });

  final bool isUser;
  final Message message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
                  isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (isUser == false)
                  CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider(message.senderImg),
                    radius: 16,
                  ),
                if (isUser == false) const SizedBox(width: 8),
                if (isUser == false)
                  Text(
                    message.senderName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            // Container
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
                            title: const Text('Delete Message'),
                            leading: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: isUser
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.messageText,
                          style: TextStyle(
                              color: isUser ? Colors.white : Colors.black),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${message.timestamp.hour}:${message.timestamp.minute} on ${message.timestamp.day}/${message.timestamp.month}/${message.timestamp.year}",
                          style: TextStyle(
                              fontSize: 10,
                              color: isUser ? Colors.white60 : Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
