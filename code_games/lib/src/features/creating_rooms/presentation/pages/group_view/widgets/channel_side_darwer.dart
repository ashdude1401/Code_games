import 'package:cached_network_image/cached_network_image.dart';
import 'package:code_games/src/features/creating_rooms/domain/entity/group_entity.dart';
import 'package:code_games/src/features/creating_rooms/presentation/stateMangement/group_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChannelSideDrawer extends StatelessWidget {
  final List<Channel> channels;

  final String groupId;
  final int channelIndex;
  final VoidCallback onTap;

  ChannelSideDrawer({
    Key? key,
    required this.channels,
    required this.groupId,
    required this.channelIndex,
    required this.onTap,
  }) : super(key: key);

  final controller = Get.find<GroupController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.builder(
        itemCount: channels.length,
        itemBuilder: (context, index) {
          final channel = channels[index].channelName;
          return ListTile(
            selectedColor: Colors.deepPurple,
            leading: CircleAvatar(
              backgroundImage:
                  CachedNetworkImageProvider(channels[index].channelImg),
            ),
            title: Text(channel),
            // assign selected property to check if the current index is selected or not
            selected: controller.currentlySelectedChannelIndex.value == index,
            onTap: () {
              print("Channel Index: $index");

              controller.currentlySelectedChannelIndex.value = index;

              onTap();

              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
