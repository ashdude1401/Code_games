import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:code_games/src/features/auth/presentation/stateMangement/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Widget/login_footer_widget.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final loginController = Get.put(LogInController());

  final imageUrl =
      "https://images.unsplash.com/photo-1607706189992-eae578626c86?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        // const BackgroundImage(),
        SizedBox(
            width: size.width,
            height: size.height,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
            )

            //  Image.network(
            //   "https://images.unsplash.com/photo-1607706189992-eae578626c86?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80",
            //   fit: BoxFit.cover,
            // ),
            ),

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
                        //   title: "Login",
                        //   subTitle: "Login to your account",
                        // ),
                        // LoginForm(size: size),
                        LoginFooterWidget()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
