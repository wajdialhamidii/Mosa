import 'package:consultation_app/utils/constants.dart';
import 'package:consultation_app/utils/sizes.dart';
import 'package:consultation_app/view_models/auth_view_model.dart';
import 'package:consultation_app/views/sign_up_screen.dart';
import 'package:consultation_app/widgets/loading_progress_indicator.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_link.dart';
import '../widgets/custom_button.dart';
import '../widgets/text_input.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final AuthViewModel _authViewModel = AuthViewModel();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                kSizedBoxHeight_60,
                Image.asset(
                  'assets/images/consultation_app_logo.png',
                  width: 150.0,
                ),
                kSizedBoxHeight_30,
                const Text(
                  'Welcome Back!',
                  style: kHeadlineTextStyle,
                ),
                kSizedBoxHeight_40,
                TextInput(
                  controller: _emailController,
                  hint: 'Email address',
                  isEmail: true,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Email address is required';
                    }
                    return null;
                  },
                ),
                kSizedBoxHeight_20,
                TextInput(
                  controller: _passwordController,
                  hint: 'Password',
                  isPassword: true,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                ),
                kSizedBoxHeight_30,
                CustomButton(
                  title: 'Login',
                  onPressed: () => _login(context),
                ),
                kSizedBoxHeight_50,
                BottomLink(
                  text: 'Don\'t have an account? ',
                  linkText: 'Sign Up',
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpScreen()));
                  },
                ),
                kSizedBoxHeight_10,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      LoadingProgressIndicator.showProgressIndicator(context);

      _authViewModel.login(
        context,
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }
}
