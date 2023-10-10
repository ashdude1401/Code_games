import 'package:cached_network_image/cached_network_image.dart';
import 'package:code_games/src/features/creating_rooms/domain/entity/group_entity.dart';
import 'package:code_games/src/features/creating_rooms/presentation/stateMangement/group_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChannelSideDrawer extends StatelessWidget {
  final List<Channel> channels;

  ChannelSideDrawer({
    Key? key,
    required this.channels,
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
            selected: index == controller.currentlySelectedChannelIndex.value,
            onTap: () {
              controller.currentlySelectedChannelIndex.value = index;
              controller.getChannelMessagesList();
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
