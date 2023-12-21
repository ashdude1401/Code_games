import 'package:cached_network_image/cached_network_image.dart';
import 'package:code_games/src/features/challenges/presentation/pages/view_challenge/view_challenge.dart';
import 'package:code_games/src/features/creating_rooms/domain/entity/group_entity.dart';
import 'package:code_games/src/features/creating_rooms/presentation/stateMangement/group_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../challenges/domain/entity/challenge.dart';

class ChannelSideDrawer extends StatelessWidget {
  final List<Channel> channels;
  final List<Challenge> challenges;

  final String groupId;
  final int channelIndex;
  final VoidCallback onTap;

  ChannelSideDrawer({
    Key? key,
    required this.channels,
    required this.groupId,
    required this.channelIndex,
    required this.onTap,
    required this.challenges,
  }) : super(key: key);

  final controller = Get.find<GroupController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(
                thickness: 1,
                height: 1,
              ),
              const Text("Channels",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  )),
              const Divider(
                thickness: 1,
                height: 1,
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: channels.length,
                  itemBuilder: (context, index) {
                    final channel = channels[index].channelName;
                    return ListTile(
                      selectedColor: Colors.deepPurple,

                      leading: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                            channels[index].channelImg),
                      ),
                      title: Text(channel),
                      // assign selected property to check if the current index is selected or not
                      selected:
                          controller.currentlySelectedChannelIndex.value ==
                              index,
                      onTap: () {
                        print("Channel Index: $index");

                        controller.currentlySelectedChannelIndex.value = index;

                        onTap();

                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              //Divider
              const Divider(
                thickness: 1,
                height: 1,
              ),
              const Text("Challenges",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  )),
              const Divider(
                thickness: 1,
                height: 1,
              ),
              //ListOfChllenges
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: challenges.length,
                  itemBuilder: (context, index) {
                    final challenge = challenges[index].title;
                    return ListTile(
                      selectedColor: Colors.deepPurple,
                      title: Text(challenge),
                      onTap: () {
                        print("Channel Index: $index");
                        Get.to(
                            () =>
                                ViewChallengePage(challenge: challenges[index],groupId: groupId,),
                            transition: Transition.rightToLeft);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
