import 'package:code_games/src/features/creating_rooms/presentation/pages/create_join_view/join_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../auth/data/repository/authentication_repository_impl.dart';
import 'create_group_page.dart';

class NewGroupView extends StatelessWidget {
  NewGroupView({
    super.key,
  });

  final AuthenticationRepositoryImpl controller =
      Get.find<AuthenticationRepositoryImpl>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Welcome to Code Games ${controller.userName.value.split(' ')[0]}",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Start Playing By",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                Get.to(() => const CreateRoomPage(),
                    transition: Transition.rightToLeftWithFade);
              },
              child: const Text("Create Group")),
          const SizedBox(
            height: 10,
          ),
          const Text("OR"),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                Get.to(() => JoinGroupView(),
                    transition: Transition.rightToLeftWithFade);
              },
              child: const Text("Join Group")),
        ],
      ),
    );
  }
}
