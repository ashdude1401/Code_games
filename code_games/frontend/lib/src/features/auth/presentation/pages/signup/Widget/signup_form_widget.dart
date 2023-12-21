import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../stateMangement/signup_controller.dart';

class SignUpFormWidget extends StatefulWidget {
  SignUpFormWidget({
    super.key,
  });

  @override
  State<SignUpFormWidget> createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  //creating instance of controller
  final controller = Get.put(SignUpController());

  final _formKey = GlobalKey<FormState>();

  final tFormHeight = 50.0;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: tFormHeight - 10,
            ),
            // TextFormField(
            //   //to pass the form data to controller
            //   controller: controller.name,
            //   keyboardType: TextInputType.name,
            //   decoration: const InputDecoration(
            //     labelText: "Name",
            //     prefixIcon: Icon(Icons.person_outline_outlined),
            //   ),
            // ),
            // SizedBox(
            //   height: tFormHeight - 20,
            // ),
            TextFormField(
              controller: controller.email,
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "Email",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            // SizedBox(
            //   height: tFormHeight - 20,
            // ),
            // TextFormField(
            //   controller: controller.phoneNo,
            //   keyboardType: TextInputType.phone,
            //   decoration: const InputDecoration(
            //     labelText: "Phone Number",
            //     prefixIcon: Icon(Icons.phone_android_outlined),
            //   ),
            // ),
            SizedBox(
              height: tFormHeight - 20,
            ),
            TextFormField(
              controller: controller.password,
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "Password",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                prefixIcon: const Icon(Icons.fingerprint_outlined),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon(
                    _obscureText
                        ? Icons.remove_red_eye_sharp
                        : Icons.visibility_off,
                  ),
                ),
              ),
              obscureText: _obscureText,
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
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
