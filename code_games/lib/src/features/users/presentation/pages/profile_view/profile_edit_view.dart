import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:code_games/src/features/auth/data/repository/authentication_repository_impl.dart';
import 'package:code_games/src/features/creating_rooms/presentation/stateMangement/group_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditView extends StatefulWidget {
  const ProfileEditView({Key? key}) : super(key: key);

  @override
  State<ProfileEditView> createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends State<ProfileEditView> {
  final controller = Get.find<AuthenticationRepositoryImpl>();
  final gropuController = Get.put(GroupController());

  late XFile? _pickedImage; // Variable to store the picked image file

  final name = TextEditingController();
  final bio = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Function to handle image picking from gallery
  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _pickedImage = pickedImage;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name.text = controller.currentUser.value.fullName;
    bio.text = controller.currentUser.value.bio.isEmpty
        ? "Hey there! I am using Code Games"
        : controller.currentUser.value.bio;

    _pickedImage = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  gropuController.updateCurrentUserDetails(
                      name.text, bio.text, _pickedImage);
                  Get.back();
                }
              },
              child: const Text("Save")),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Profile Picture',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 5),
              // Circle avatar to display picked image or default profile image
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                child: _pickedImage == null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: controller.currentUser.value.profilePicture,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.file(
                          File(_pickedImage!.path),
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed:
                    _pickImage, // Call pick image function when button is pressed
                child: const Text('Pick Image'),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      'Name',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(height: 5),
                    // Text field to display and edit name
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      // Update name when text changes
                      controller: name,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Bio',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(height: 5),
                    // Text field to display and edit bio
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: bio, // Set initial value
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Email',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      enabled: false,
                      // onChanged: (value) =>
                      //     _bio = value, // Update bio when text changes
                      controller: TextEditingController(
                          text: controller.email.value), // Set initial value
                    ),
                  ],
                ),
              ), // Display user's email
            ],
          ),
        ),
      ),
    );
  }
}
