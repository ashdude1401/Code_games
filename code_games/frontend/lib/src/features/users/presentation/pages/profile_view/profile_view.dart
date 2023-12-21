import 'package:cached_network_image/cached_network_image.dart';
import 'package:code_games/src/features/auth/data/models/user_modal.dart';

import 'package:code_games/src/features/users/presentation/pages/profile_view/profile_edit_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../auth/data/repository/authentication_repository_impl.dart';


class ProfileView extends StatefulWidget {
  ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final controller = Get.find<AuthenticationRepositoryImpl>();
  // final gropuController = Get.find<GroupController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Get.to(() => const ProfileEditView(),
                            transition: Transition.rightToLeftWithFade);
                      },
                      child: const Text("Edit Profile")),
                ],
              ),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,

                backgroundImage: CachedNetworkImageProvider(controller
                    .currentUser.value.profilePicture), // Display profile image
              ),

              const SizedBox(height: 20),
              const Text(
                'Name',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 5),
              // Text field to display and edit name
              TextFormField(
                readOnly: true,
                // Update name when text changes
                controller: TextEditingController(
                    text: controller.currentUser.value.fullName),
                // Set initial value
              ),
              const SizedBox(height: 20),
              const Text(
                'Bio',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 5),
              // Text field to display and edit bio
              TextFormField(
                  readOnly: true, // Update bio when text changes
                  controller: TextEditingController(
                    text: controller.currentUser.value.bio.isEmpty
                        ? "I am cool"
                        : controller.currentUser.value.bio,
                  ) // Set initial value
                  ),
              const SizedBox(height: 20),
              const Text(
                'Email',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 5),
              TextFormField(
                readOnly: true,
                // onChanged: (value) =>
                //     _bio = value, // Update bio when text changes
                controller: TextEditingController(text: controller.currentUser.value.email),
                // Set initial value
              ), // Display user's email
            ],
          ),
        ),
      ),
    );
  }
}
