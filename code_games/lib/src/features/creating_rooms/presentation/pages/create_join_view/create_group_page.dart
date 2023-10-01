import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../stateMangement/group_controller.dart';

class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({Key? key}) : super(key: key);

  @override
  _CreateRoomPageState createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  final controller = Get.put(GroupController());
  final _formKey = GlobalKey<FormState>();

  late XFile? _pickedImage;

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
    _pickedImage = null;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Group'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  // Handle image selection here
                  // controller.pickImage(Method.gallery);
                },
                child: _pickedImage == null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey,
                        backgroundImage: controller.groupImg.isNotEmpty
                            ? AssetImage(controller.groupImg)
                            : null,
                        child: const Icon(CupertinoIcons.camera_fill),
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
              const SizedBox(height: 16.0),
              TextFormField(
                controller: controller.groupName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter group name';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Group Name',
                  hintText: 'Enter group name',
                  hintStyle: TextStyle(color: Colors.black),
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: controller.groupDescription,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter group description';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Group Description',
                  hintText: 'Enter group description',
                  hintStyle: TextStyle(color: Colors.black),
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: controller.challengeAmount,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter challenge amount';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Challenge Amount',
                  hintText: 'Enter challenge amount',
                  hintStyle: TextStyle(color: Colors.black),
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: controller.challengeParameters,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter challenge parameters';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Challenge Parameters',
                  hintText: 'Enter challenge parameters',
                  hintStyle: TextStyle(color: Colors.black),
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    controller.createGroup();
                  }
                },
                child: const Text('Create Group'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
