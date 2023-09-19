import 'package:flutter/material.dart';

import '../../../stateMangement/signup_controller.dart';

class SignUpFooterWidget extends StatelessWidget {
  const SignUpFooterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text("OR"),
      const SizedBox(
        height: 40 - 24,
      ),
      SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () {
            SignUpController.instance.registerUserWithGoogle();
          },
          icon: const Icon(Icons.g_mobiledata_outlined),
          label: Text("Google sign in ".toUpperCase()),
        ),
      ),
      const SizedBox(
        height: 40 - 24,
      ),
      TextButton(
        onPressed: () {},
        child: Text.rich(
          TextSpan(
            text: "Already have an account? ",
            style: Theme.of(context).textTheme.bodyLarge,
            children: const [
              TextSpan(text: "Login", style: TextStyle(color: Colors.blue))
            ],
          ),
        ),
      )
    ]);
  }
}
