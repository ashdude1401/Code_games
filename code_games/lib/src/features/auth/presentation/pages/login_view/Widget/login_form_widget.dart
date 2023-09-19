import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.size,
  });

  final Size size;

  static const tFormHeight = 40.0;

  @override
  Widget build(BuildContext context) {

    return Form(
        child: Container(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person_outline_outlined),
              labelText: "Email",
              hintText: "Email",
            ),
          ),
          const SizedBox(
            height: tFormHeight - 14,
          ),
          TextFormField(
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.fingerprint),
                labelText: "Password",
                hintText:"Password",
                suffixIcon: Icon(
                  Icons.remove_red_eye_sharp,
                )),
          ),
          const SizedBox(
            height: tFormHeight - 24,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // ForgetPasswordModel.buidBottomSheet(context, modelSize);
              },
              child: const Text(
                "Forget Password",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: Text(
                "Login".toUpperCase(),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
