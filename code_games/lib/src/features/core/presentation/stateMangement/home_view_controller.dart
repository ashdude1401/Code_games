import 'package:code_games/src/features/users/presentation/pages/all_users_view/all_users_view.dart';
import 'package:code_games/src/features/users/presentation/pages/profile_view/profile_edit_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../creating_rooms/presentation/pages/user_group_list_view/user_groups_list_view.dart';
import '../../../creating_rooms/presentation/pages/create_join_view/new_group.dart';

class HomeViewController extends GetxController {
  List<Widget> pages = [
    NewGroupView(),
    const UserGroupListView(),
    const ProfileEditView(),
    const AllUsersView()
  ];
  final Rx<Widget> _currentPage = Rx<Widget>(NewGroupView());

  Widget get currentPage => _currentPage.value;

  set currentPage(Widget value) {
    _currentPage.value = value;
  }
}
