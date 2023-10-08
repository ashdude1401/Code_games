import 'package:code_games/src/features/creating_rooms/presentation/pages/group_view/add_member_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:get/get.dart';

import '../../stateMangement/group_controller.dart';

class GroupDetailView extends StatefulWidget {
  const GroupDetailView({
    Key? key,
  }) : super(key: key);

  @override
  State<GroupDetailView> createState() => _GroupDetailViewState();
}

class _GroupDetailViewState extends State<GroupDetailView> {
  final controller = Get.find<GroupController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Detail'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(controller
                      .userRooms
                      .value[controller.currentlySelectedGroupIndex.value]
                      .groupImg),
                  radius: 50,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  controller
                      .userRooms
                      .value[controller.currentlySelectedGroupIndex.value]
                      .groupName,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    controller
                        .userRooms
                        .value[controller.currentlySelectedGroupIndex.value]
                        .groupDescription,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                IconButton(
                  onPressed: () {
                    Get.to(const AddGroupMember());
                  },
                  iconSize: 40,
                  icon: const Icon(CupertinoIcons.person_add_solid),
                ),
                const SizedBox(width: 20),
                IconButton(
                  iconSize: 40,
                  onPressed: () {},
                  icon: const Icon(CupertinoIcons.chat_bubble_text_fill),
                ),
                //edit group
                const SizedBox(width: 20),
                IconButton(
                  iconSize: 40,
                  onPressed: () {},
                  icon: const Icon(CupertinoIcons.pencil_circle_fill),
                )
              ]),
              // const SizedBox(height: 20),
              // _buildExpansionTile('Challenge Details', _buildChallenges()),
              const SizedBox(height: 20),
              Obx(
                () => _buildListTile(
                  'Group Members',
                  _buildMembers(),
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => _buildListTile(
                  'Administrators',
                  _buildAdmins(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpansionTile(String title, Widget content) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      children: [content],
    );
  }

  Widget _buildListTile(String title, Widget content) {
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: content,
        //add button to add members
      ),
    );
  }

  // Widget _buildChallenges() {
  //   return Column(
  //     children: controller.userRooms
  //         .value[controller.currentlySelectedGroupIndex.value].challengeList
  //         .map(
  //           (challenge) => ListTile(
  //             title: Text(challenge.challengeName),
  //             subtitle: Text(challenge.challengeDescription),
  //           ),
  //         )
  //         .toList(),
  //   );
  // }

  Widget _buildMembers() {
    return Column(
      children: controller.userRooms
          .value[controller.currentlySelectedGroupIndex.value].groupMembers
          .map(
            (member) => ListTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(member.userImg),
              ),
              title: Text(member.userName),
              subtitle: Text(member.email),
            ),
          )
          .toList(),
    );
  }

  Widget _buildAdmins() {
    return Column(
      children: controller
          .userRooms.value[controller.currentlySelectedGroupIndex.value].admins
          .map(
            (admin) => ListTile(
              title: Text(admin),
            ),
          )
          .toList(),
    );
  }
}
