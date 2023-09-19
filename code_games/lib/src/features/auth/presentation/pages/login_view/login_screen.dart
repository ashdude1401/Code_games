import 'package:flutter/material.dart';
import '../../../../../core/utils/common_widgets/Form/form_header.dart';
import 'Widget/login_footer_widget.dart';
import 'Widget/login_form_widget.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

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
                  title: "Login",
                  subTitle: "Login to your account",
                ),
                LoginForm(size: size),
                const LoginFooterWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
