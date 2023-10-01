import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/repository/authentication_repository_impl.dart';

class LogInController extends GetxController {
  //getter method for this controller , so that we can access this controller from anywhere

  static LogInController get instance => Get.find();

  //TextFeild Controllers to get data from TextFeilds
  final email = TextEditingController();
  final password = TextEditingController();

  //To Register User
  void loginUser(String email, String password) {
    AuthenticationRepositoryImpl.instance
        .loginWithTheEmailAndPassword(email, password);
  }

  //To Register User with Google
  void loginUserWithGoogle() {
    AuthenticationRepositoryImpl.instance.signInWithGoogle();
  }

  //Logout user
  void logout() {
    AuthenticationRepositoryImpl.instance.logout();
  }
}
