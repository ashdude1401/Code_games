import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../stateMangement/signup_controller.dart';

class SignUpFormWidget extends StatelessWidget {
  SignUpFormWidget({
    super.key,
  });

  //creating instance of controller
  final controller = Get.put(SignUpController());

  final _formKey = GlobalKey<FormState>();

  final tFormHeight = 50.0;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(
            height: tFormHeight - 10,
          ),
          TextFormField(
            //to pass the form data to controller
            controller: controller.name,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
              labelText: "Name",
              prefixIcon: Icon(Icons.person_outline_outlined),
            ),
          ),
          SizedBox(
            height: tFormHeight - 20,
          ),
          TextFormField(
            controller: controller.email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "Email",
              prefixIcon: Icon(
                Icons.email_outlined,
                color: Colors.deepPurple,
              ),
            ),
          ),
          SizedBox(
            height: tFormHeight - 20,
          ),
          TextFormField(
            controller: controller.phoneNo,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: "Phone Number",
              prefixIcon: Icon(Icons.phone_android_outlined),
            ),
          ),
          SizedBox(
            height: tFormHeight - 20,
          ),
          TextFormField(
            controller: controller.password,
            keyboardType: TextInputType.visiblePassword,
            decoration: const InputDecoration(
              labelText: "Password",
              prefixIcon: Icon(Icons.fingerprint_outlined),
            ),
          ),
          SizedBox(
            height: tFormHeight - 10,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                //to validate the form
                if (_formKey.currentState!.validate()) {
                  controller.registerUser(controller.email.text.trim(),
                      controller.password.text.trim());
                }
              },
              child: Text(
                "Sign up".toUpperCase(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
