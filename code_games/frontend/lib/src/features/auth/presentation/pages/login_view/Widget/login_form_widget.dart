import 'package:code_games/src/features/auth/presentation/stateMangement/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.size,
  });

  final Size size;

  static const tFormHeight = 40.0;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final controller = Get.put(LogInController());

  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Container(
      padding: EdgeInsets.symmetric(vertical: widget.size.height * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller.email,
            style: const TextStyle(color: Colors.white),
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person_outline_outlined),
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
              labelText: "Email",
              hintText: "Email",
            ),
          ),
          const SizedBox(
            height: LoginForm.tFormHeight - 14,
          ),
          TextFormField(
            controller: controller.password,
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.fingerprint),
              labelText: "Password",
              hintText: "Password",
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
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
          const SizedBox(
            height: LoginForm.tFormHeight - 24,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // ForgetPasswordModel.buidBottomSheet(context, modelSize);
              },
              child: const Text(
                "Forget Password",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                //to validate the form
                if (_formKey.currentState!.validate()) {
                  controller.loginUser(controller.email.text.trim(),
                      controller.password.text.trim());
                }
              },
              child: Text("Login".toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                  )),
            ),
          )
        ],
      ),
    ));
  }
}
