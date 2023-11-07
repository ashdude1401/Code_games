import 'package:code_games/src/features/auth/data/repository/authentication_repository_impl.dart';
import 'package:code_games/src/features/users/presentation/pages/all_users_view/all_users_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../creating_rooms/presentation/pages/user_group_list_view/user_groups_list_view.dart';
import '../../../creating_rooms/presentation/pages/create_join_view/new_group.dart';
import '../../../users/presentation/pages/profile_view/profile_view.dart';

class HomeViewController extends GetxController {
  final controller = Get.find<AuthenticationRepositoryImpl>();
  List<Widget> pages = [
    NewGroupView(),
    UserGroupListView(),
    ProfileView(),
    const AllUsersView()
  ];
  final Rx<Widget> _currentPage = Rx<Widget>(NewGroupView());

  final currentIndex = 0.obs;

  Widget get currentPage => _currentPage.value;

  set currentPage(Widget value) {
    _currentPage.value = value;
  }
}
