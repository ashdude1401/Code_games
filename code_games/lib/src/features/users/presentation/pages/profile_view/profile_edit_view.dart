import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:code_games/src/features/auth/data/repository/authentication_repository_impl.dart';
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
  late String _name = 'John Doe'; // Default name
  late String _bio = 'I am a software developer'; // Default bio
  late XFile? _pickedImage; // Variable to store the picked image file

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

    _name = controller.userName.value;
    _bio = controller.bio.value;
    _pickedImage = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
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
                // backgroundImage: _pickedImage != null
                //     ? FileImage(File(_pickedImage!.path)) // Display picked image
                //     : AssetImage('assets/images/profile.png'),
                child: _pickedImage == null
                    ? CachedNetworkImage(
                        imageUrl: controller.profilePicture.value,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
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
              const Text(
                'Name',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 5),
              // Text field to display and edit name
              TextField(
                onChanged: (value) =>
                    _name = value, // Update name when text changes
                controller:
                    TextEditingController(text: _name), // Set initial value
              ),
              const SizedBox(height: 20),
              const Text(
                'Bio',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 5),
              // Text field to display and edit bio
              TextField(
                onChanged: (value) =>
                    _bio = value, // Update bio when text changes
                controller: TextEditingController(
                    text: _bio.isEmpty
                        ? "I am cool"
                        : controller.bio.value), // Set initial value
              ),
              const SizedBox(height: 20),
              const Text(
                'Email',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 5),
              TextField(
                enabled: false,
                // onChanged: (value) =>
                //     _bio = value, // Update bio when text changes
                controller: TextEditingController(
                    text: controller.email.value), // Set initial value
              ), // Display user's email
            ],
          ),
        ),
      ),
    );
  }
}
