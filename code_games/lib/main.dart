import 'package:code_games/src/features/creating_rooms/data/repository/group_repository_impl.dart';
import 'package:code_games/src/features/creating_rooms/presentation/stateMangement/group_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';
import 'src/config/theme/Theme/theme.dart';
import 'src/features/auth/data/repository/authentication_repository_impl.dart';
import 'src/features/core/presentation/pages/home/home_view/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  )
      //After intialization firebase creating AuthenticationRepositoryImpl instance to handle all the authentication stuff
      .then((value) => Get.put(AuthenticationRepositoryImpl()))
      .then((value) => Get.put(GroupRepositoryImpl()))
      .then((value) => Get.put(GroupController()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Code Games',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    );
  }
}
