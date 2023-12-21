import 'package:code_games/src/features/auth/presentation/stateMangement/login_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../signup/singup_screen.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({
    super.key,
  });

  static const double tFormHeight = 40;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // const Text(
      //   "OR",
      //   style: TextStyle(
      //     color: Colors.white,
      //   ),
      // ),
      // const SizedBox(
      //   height: tFormHeight - 24,
      // ),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            LogInController.instance.loginUserWithGoogle();
          },
          icon: const Icon(
            Icons.g_mobiledata_outlined,
            color: Colors.white,
          ),
          label: Text(
            "Google sign in".toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      const SizedBox(
        height: tFormHeight - 24,
      ),
      TextButton(
        onPressed: () {
          Get.to(() => const SignUpScreen(),
              transition: Transition.rightToLeft);
        },
        child: Text.rich(
          TextSpan(
            text: "Don't have an account? ",
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
            ),
            children: const [
              TextSpan(
                  text: "Sign Up",
                  style: TextStyle(color: Colors.white, fontSize: 15))
            ],
          ),
        ),
      )
    ]);
  }
}
