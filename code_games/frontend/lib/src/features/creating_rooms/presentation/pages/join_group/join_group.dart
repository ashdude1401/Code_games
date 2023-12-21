import 'package:code_games/src/features/creating_rooms/presentation/stateMangement/group_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../auth/data/repository/authentication_repository_impl.dart';

class JoinGroupView extends StatefulWidget {
  @override
  _JoinGroupViewState createState() => _JoinGroupViewState();
}

class _JoinGroupViewState extends State<JoinGroupView> {
  final controller = Get.find<GroupController>();
  final TextEditingController _groupIdController = TextEditingController();

  @override
  void dispose() {
    _groupIdController.dispose();
    super.dispose();
  }

  void _joinGroup() {
    String groupId = _groupIdController.text;
    controller.joinGroup(groupId);
    // TODO: Implement joining the group with the given ID
    print('Joining group with ID: $groupId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Please enter the group ID to join the group",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _groupIdController,
              decoration: const InputDecoration(
                labelText: 'Group ID',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _joinGroup,
              child: const Text('Join Group'),
            ),
          ],
        ),
      ),
    );
  }
}
