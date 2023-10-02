import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:code_games/src/features/creating_rooms/presentation/stateMangement/group_controller.dart';

class AddGroupMember extends StatefulWidget {
  const AddGroupMember({Key? key}) : super(key: key);

  @override
  State<AddGroupMember> createState() => _AddGroupMemberState();
}

class _AddGroupMemberState extends State<AddGroupMember> {
  final controller = Get.find<GroupController>();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    controller.selectedUsers.clear();
    controller.filteredUsers.clear();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Member'),
      ),
      body: Obx(
        () => controller.isLoading == false
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        labelText: 'Enter Member Email',
                        hintText: 'Enter Member Email',
                        hintStyle: TextStyle(color: Colors.grey),
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (query) {
                        controller.filterUsers(query);
                      },
                    ),
                    const SizedBox(height: 20),

                    Row(
                        children: controller.selectedUsers
                            .map(
                              (user) => CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    user.profilePicture),
                              ),
                            )
                            .toList()),

                    // Show the number of users found
                    Row(
                      children: [
                        const Text('Users'),
                        const Spacer(),
                        Text('${controller.filteredUsers.length} found'),
                      ],
                    ),

                    Obx(
                      () => Expanded(
                        child: ListView.builder(
                          itemCount: controller.filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = controller.filteredUsers[index];

                            return ListTile(
                              onTap: () {
                                if (controller.isSelected(user)) {
                                  controller.deselectUser(user);
                                  setState(() {});
                                } else {
                                  controller.selectUser(user);
                                  setState(() {});
                                }
                              },
                              title: Text(user.email),
                              subtitle: Text(user.fullName),
                              leading: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    user.profilePicture),
                              ),
                              trailing: controller.isSelected(user)
                                  ? const Icon(Icons.check_circle,
                                      color: Colors.green)
                                  : null,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await controller.addMembers();
                      },
                      child: const Text('Add Members'),
                    ),
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
