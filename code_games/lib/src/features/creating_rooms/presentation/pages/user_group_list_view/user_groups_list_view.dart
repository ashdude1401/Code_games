import 'package:cached_network_image/cached_network_image.dart';

import 'package:code_games/src/features/creating_rooms/presentation/stateMangement/group_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../group_view/group_chat_view.dart';

class UserGroupListView extends StatefulWidget {
  const UserGroupListView({Key? key}) : super(key: key);

  @override
  State<UserGroupListView> createState() => _UserGroupListViewState();
}

class _UserGroupListViewState extends State<UserGroupListView> {
  final controller = Get.put(GroupController());

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      controller.getUserRooms();
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Obx(
      () => controller.isLoading.value == true
          ? const Center(child: CircularProgressIndicator())
          : controller.userRooms.value.isNotEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // You can remove this since the data is fetched in initState
                        // controller.getUserRooms();
                      },
                      child: const Text("Groups"),
                    ),
                    //showing all userRooms
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.userRooms.value.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              controller.currentlySelectedGroupIndex.value =
                                  index;
                              Get.to(
                                  () => GroupChatView(
                                      group: controller.userRooms.value[index]),
                                  transition: Transition.rightToLeftWithFade);
                            },
                            title: Text(
                                controller.userRooms.value[index].groupName),
                            subtitle: Text(controller
                                .userRooms.value[index].groupDescription),
                            leading: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                controller.userRooms.value[index].groupImg,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              : const Center(child: Text("No Groups Found")),
    ));
  }
}
