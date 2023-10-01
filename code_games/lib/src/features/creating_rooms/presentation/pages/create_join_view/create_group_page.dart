import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../stateMangement/group_controller.dart';

class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({Key? key}) : super(key: key);

  @override
  _CreateRoomPageState createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  final controller = Get.put(GroupController());

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Room'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Group Image',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  // controller.pickImage(Method.gallery);
                  // setState(() {});
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  backgroundImage: controller.groupImg.isNotEmpty
                      ? AssetImage(controller.groupImg)
                      : null,
                ),
              ),
              const Text(
                'Group Name',
                style: TextStyle(fontSize: 18.0),
              ),
              TextFormField(
                controller: controller.groupName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Enter group name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Group Description',
                style: TextStyle(fontSize: 18.0),
              ),
              TextFormField(
                controller: controller.groupDescription,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Enter group description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Challenge Amount',
                style: TextStyle(fontSize: 18.0),
              ),
              TextFormField(
                controller: controller.challengeAmount,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter challenge amount',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Challenge Parameters',
                style: TextStyle(fontSize: 18.0),
              ),
              TextFormField(
                controller: controller.challengeParameters,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Enter challenge parameters',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  // Handle form submission here
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
