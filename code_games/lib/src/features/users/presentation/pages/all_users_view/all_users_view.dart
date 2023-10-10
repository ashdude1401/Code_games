import 'package:cached_network_image/cached_network_image.dart';
import 'package:code_games/src/features/creating_rooms/presentation/stateMangement/group_controller.dart';

import 'package:code_games/src/features/users/presentation/pages/all_users_view/user_profile_view.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllUsersView extends StatefulWidget {
  const AllUsersView({super.key});

  @override
  State<AllUsersView> createState() => _AllUsersViewState();
}

class _AllUsersViewState extends State<AllUsersView> {
  final controller = Get.put(GroupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
      ),
      body: Obx(() => controller.isLoading.value == true
          ? const Center(child: CircularProgressIndicator())
          : controller.allUsers.value.isNotEmpty
              ? Column(
                  children: [
                    Expanded(
                        child: ListView.builder(
                      itemBuilder: (context, index) => ListTile(
                        onTap: () {
                          Get.to(
                              () => UserProfileView(
                                  showEditProfile: false,
                                  user: controller.allUsers.value[index]),
                              transition: Transition.rightToLeft);
                        },
                        title: Text(controller.allUsers.value[index].fullName),
                        leading: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                              controller.allUsers.value[index].profilePicture),
                        ),
                      ),
                      itemCount: controller.allUsers.value.length,
                    )),
                  ],
                )
              : const Center(child: Text("No Users Found"))),
    );
  }
}
