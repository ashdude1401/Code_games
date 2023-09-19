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
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.deepOrange : Colors.white,
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.pets_outlined,
                  size: size.height * 0.2,
                ),
                Column(
                  children: [
                    Text(
                      "Welcome to Pet World",
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Text("Find your pet's best friend",
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.to(() => const LoginView()),
                        child: Text(
                          "Login".toUpperCase(),
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
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
                        onPressed: () => Get.to(() => const SignUpScreen()),
                        child: Text(
                          "Sign up".toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  color: Colors.deepOrange,
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
    );
  }
}
