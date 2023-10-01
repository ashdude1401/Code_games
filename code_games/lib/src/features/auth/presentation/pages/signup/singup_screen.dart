import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:code_games/src/features/auth/presentation/stateMangement/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Widget/signup_footer.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final controller = Get.put(SignUpController());

  final imageUrl =
      "https://images.unsplash.com/photo-1607706189992-eae578626c86?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80";
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        SizedBox(
            width: size.width,
            height: size.height,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
            )),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    height: size.height,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // FormHeaderWidget(
                        //   size: size,
                        //   hdrImg: "",
                        //   title: "Sign Up",
                        //   subTitle: "Create an account to continue",
                        // ),
                        // SignUpFormWidget(),
                        SignUpFooterWidget(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
