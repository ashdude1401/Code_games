import 'package:code_games/src/features/auth/presentation/pages/signup/singup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../stateMangement/signup_controller.dart';

class SignUpFooterWidget extends StatelessWidget {
  const SignUpFooterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // const Text("OR",
      //     style: TextStyle(
      //       color: Colors.white,
      //     )),
      // const SizedBox(
      //   height: 40 - 24,
      // ),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            SignUpController.instance.registerUserWithGoogle();
          },
          icon: const Icon(
            Icons.g_mobiledata_outlined,
            color: Colors.white,
          ),
          label: Text("Google sign in ".toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
              )),
        ),
      ),
      const SizedBox(
        height: 40 - 24,
      ),
      TextButton(
        onPressed: () {
          Get.to(() => const SignUpScreen(),
              transition: Transition.rightToLeft);
        },
        child: Text.rich(
          TextSpan(
            text: "Already have an account? ",
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
            ),
            children: const [
              TextSpan(
                text: "Login",
                style: TextStyle(color: Colors.white, fontSize: 15),
              )
            ],
          ),
        ),
      )
    ]);
  }
}
