import 'package:cached_network_image/cached_network_image.dart';
import 'package:code_games/src/features/creating_rooms/presentation/pages/user_group_list_view/user_groups_list_view.dart';
import 'package:code_games/src/features/users/presentation/pages/all_users_view/all_users_view.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../auth/data/repository/authentication_repository_impl.dart';
import '../../../../../users/presentation/pages/profile_view/profile_view.dart';
import '../../../stateMangement/home_view_controller.dart';
import '../../../../../creating_rooms/presentation/pages/create_join_view/new_group.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    super.key,
    required this.reverse,
    required this.forward,
  });

  final VoidCallback reverse;
  final VoidCallback forward;

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final controller = Get.find<AuthenticationRepositoryImpl>();
  final homeViewController = Get.find<HomeViewController>();
  String imageUrl =
      "https://images.unsplash.com/photo-1615812214207-34e3be6812df?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80";

  String userName = "Code Geek";
  String userBio = "Paisa hi Paisa";

  @override
  Widget build(BuildContext context) {
    userName = controller.userName.value;
    imageUrl = controller.profilePicture.value;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFF17203A),
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: size.width * 0.75,
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
          ),
          color: const Color(0xFF17203A),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                    radius: 40,
                    backgroundImage: CachedNetworkImageProvider(imageUrl)),
                ListTile(
                  onTap: () {
                    homeViewController.currentPage = ProfileView();
                    widget.reverse();
                  },
                  title: Text(
                    userName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    userBio,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
                Divider(
                  color: Colors.white.withOpacity(0.2),
                  height: 40,
                ),
                InkWell(
                    onTap: () {
                      homeViewController.currentPage = NewGroupView();
                      widget.reverse();
                    },
                    splashColor: Colors.white,
                    highlightColor: Colors.white,
                    child: Obx(
                      () => ListTile(
                        leading: Icon(
                          homeViewController.currentPage is NewGroupView
                              ? CupertinoIcons
                                  .plus_rectangle_fill_on_rectangle_fill
                              : CupertinoIcons.plus_rectangle_on_rectangle,
                          color: Colors.white,
                        ),
                        title: const Text(
                          "New Group",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
                ListTile(
                  onTap: () {
                    homeViewController.currentPage = UserGroupListView();
                    widget.reverse();
                  },
                  leading: Obx(
                    () => Icon(
                      homeViewController.currentPage is UserGroupListView
                          ? CupertinoIcons.bubble_left_fill
                          : CupertinoIcons.bubble_left,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text(
                    "Groups",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  onTap: () {
                    homeViewController.currentPage = const AllUsersView();
                    widget.reverse();
                  },
                  leading: Icon(
                    homeViewController.currentPage is AllUsersView
                        ? CupertinoIcons.person_2_fill
                        : CupertinoIcons.person_2,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "Users",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const ListTile(
                  leading: Icon(
                    //Singal icon
                    CupertinoIcons.chart_bar,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Analytics",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),

                const ListTile(
                  leading: Icon(
                    CupertinoIcons.bookmark,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Collections",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),

                //divider
                Divider(
                  color: Colors.white.withOpacity(0.2),
                  height: 40,
                ),

                const ListTile(
                  leading: Icon(
                    CupertinoIcons.settings,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Settings",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                //logout
                ListTile(
                  onTap: () {
                    controller.logout();
                  },
                  leading: const Icon(
                    CupertinoIcons.square_arrow_left,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "Logout",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
