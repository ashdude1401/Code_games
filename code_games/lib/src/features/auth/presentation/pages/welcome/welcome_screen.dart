import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../login_view/login_screen.dart';
import '../signup/singup_screen.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  static const routeName = '/welcomeScreen';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        SizedBox(
          width: size.width,
          height: size.height,
          child: Image.network(
            "https://images.unsplash.com/photo-1607706189992-eae578626c86?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80",
            fit: BoxFit.cover,
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        //coding icon
                        CupertinoIcons.square_grid_2x2_fill,
                        size: size.height * 0.2,
                        color: const Color(0xffF2F2F2),
                      ),
                      Column(
                        children: [
                          const Text(
                            "Welcome to Code Games",
                            style: TextStyle(
                              color: Color(0xffF2F2F2),
                              fontSize: 30,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          Text(
                            "Join and code with friend",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xffF2F2F2).withOpacity(0.8),
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Get.to(() => const LoginView(),
                                  transition: Transition.rightToLeft),
                              child: Text(
                                "Login".toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: size.height * 0.015,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Get.to(
                                  () => const SignUpScreen(),
                                  transition: Transition.rightToLeft),
                              child: Text(
                                "Sign up".toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
