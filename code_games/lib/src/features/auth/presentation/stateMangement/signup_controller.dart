import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/repository/authentication_repository_impl.dart';
class SignUpController extends GetxController {
  //getter method for this controller , so that we can access this controller from anywhere

  static SignUpController get instance => Get.find();

  //TextFeild Controllers to get data from TextFeilds
  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  final phoneNo = TextEditingController();

  //To Register User
  void registerUser(String email, String password) {
    AuthenticationRepositoryImpl.instance
        .createUserWithEmailAndPassword(email, password);
  }

  //To Register User with Google
  void registerUserWithGoogle() {
    AuthenticationRepositoryImpl.instance.signInWithGoogle();
  }

  //Logout user
  void logout() {
    AuthenticationRepositoryImpl.instance.logout();
  }
}
