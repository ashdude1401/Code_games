import 'package:flutter/material.dart';
import '../../../../../core/utils/common_widgets/Form/form_header.dart';
import 'Widget/signup_footer.dart';
import 'Widget/signup_form_widget.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FormHeaderWidget(
                  size: size,
                  hdrImg: "",
                  title: "Sign Up",
                  subTitle: "Create an account to continue",
                ),
                SignUpFormWidget(),
                const SignUpFooterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
