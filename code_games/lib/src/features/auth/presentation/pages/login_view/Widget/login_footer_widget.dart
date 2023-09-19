import 'package:flutter/material.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({
    super.key,
  });

  static const double tFormHeight = 40;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text("OR"),
      const SizedBox(
        height: tFormHeight - 24,
      ),
      SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.g_mobiledata_outlined),
          label: Text("Google sign in".toUpperCase()),
        ),
      ),
      const SizedBox(
        height: tFormHeight - 24,
      ),
      TextButton(
        onPressed: () {},
        child: Text.rich(
          TextSpan(
            text: "Don't have an account? ",
            style: Theme.of(context).textTheme.bodyLarge,
            children: const [
              TextSpan(text: "Sign Up", style: TextStyle(color: Colors.blue))
            ],
          ),
        ),
      )
    ]);
  }
}
