import 'package:cached_network_image/cached_network_image.dart';
import 'package:code_games/src/features/auth/data/models/user_modal.dart';

import 'package:code_games/src/features/users/presentation/pages/profile_view/profile_edit_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key, required this.user}) : super(key: key);

  final UserEntity user;

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

                backgroundImage: CachedNetworkImageProvider(
                    user.profilePicture), // Display profile image
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
                controller: TextEditingController(text: user.fullName),
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
                    text: user.bio.isEmpty ? "I am cool" : user.bio,
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
                controller: TextEditingController(text: user.email),
                // Set initial value
              ), // Display user's email
            ],
          ),
        ),
      ),
    );
  }
}
