import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repository/authentication_repository_impl.dart';
import '../welcome/welcome_screen.dart';


class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  //Animation
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    //Animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    _animationController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      AuthenticationRepositoryImpl.instance.firebaseUser.value != null
          ? Get.offAll(() => HomeView())
          : Get.offAll(() => const WelcomeView());
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          gradient: LinearGradient(
              transform: GradientRotation(pi / 4),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.deepPurpleAccent,
                Colors.deepPurple,
              ]),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animation.value * 1.5,
                      child: AnimatedOpacity(
                        opacity: _animation.value,
                        duration: const Duration(seconds: 1),
                        child: Icon(
                          Icons.bubble_chart,
                          size: size.width * 0.5,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) => AnimatedOpacity(
                  opacity: _animation.value,
                  duration: const Duration(seconds: 1),
                  child: Transform.translate(
                      offset: Offset(0, 100 - 100 * _animation.value),
                      child: child),
                ),
                child: Column(
                  children: [
                    Text(
                      'Pet World',
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    Text(
                      'New way paltform for pet lovers',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ]),
      ),
    ));
  }
}
