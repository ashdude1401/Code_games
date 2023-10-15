import 'package:cached_network_image/cached_network_image.dart';

import 'package:code_games/src/features/core/presentation/pages/home/side_menu/side_menu.dart';
import 'package:code_games/src/features/core/presentation/stateMangement/home_view_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../auth/data/repository/authentication_repository_impl.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  final controller = Get.find<AuthenticationRepositoryImpl>();

  final homeViewContoller = Get.put(HomeViewController());

  late final AnimationController animationController;
  late final Animation<double> animation;

  @override
  void initState() {
    homeViewContoller.currentPage = homeViewContoller.pages[0];
    // Initialize the animation controller
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    // Define the animation with an ease-out curve
    animation = CurvedAnimation(
        parent: animationController,
        curve: Curves.fastEaseInToSlowEaseOut,
        reverseCurve: Curves.easeIn);

    // TODO: implement initState
    super.initState();
  }

  void reverseAnimation() {
    animationController.reverse();
  }

  void forwarAnimaition() {
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => animationController.reverse(),
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          // Right swipe detected, open the side menu
          animationController.forward();
        } else if (details.primaryVelocity! < 0) {
          // Left swipe detected, close the side menu
          animationController.reverse();
        }
      },
      child: Scaffold(
          body: Stack(
            children: [
              // Side Menu
              SideMenu(
                forward: forwarAnimaition,
                reverse: reverseAnimation,
              ),
              AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    return Transform(
                      transform: Matrix4.rotationY(animation.value * 0.5),
                      child: Transform.translate(
                        offset:
                            Offset(size.width * (animation.value * 0.75), 0),
                        child: Transform.scale(
                          scale: 1 - (animation.value * 0.3),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(40 * animation.value),
                            child: Scaffold(
                              appBar: AppBar(
                                automaticallyImplyLeading: false,
                                centerTitle: true,
                                leading: GestureDetector(
                                  onTap: () {
                                    animationController.forward();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                        controller.profilePicture.value,
                                      ),
                                    ),
                                  ),
                                ),
                                title: const Text("Code Games"),
                              ),
                              body: child ?? Container(),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Obx(() => homeViewContoller.currentPage)),
            ],
          ),
          //bottomNaviagtionBar showing all the pages in the app
          bottomNavigationBar: Obx(
            () => BottomNavigationBar(
              currentIndex: homeViewContoller.currentIndex.value,
              onTap: (index) {
                homeViewContoller.currentIndex.value = index;
                homeViewContoller.currentPage = homeViewContoller.pages[index];
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.group),
                  label: 'Groups',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          )),
    );
  }
}
