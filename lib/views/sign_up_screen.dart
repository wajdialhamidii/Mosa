import 'package:consultation_app/models/client.dart';
import 'package:consultation_app/view_models/client_view_model.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/sizes.dart';
import '../widgets/bottom_link.dart';
import '../widgets/custom_button.dart';
import '../widgets/loading_progress_indicator.dart';
import '../widgets/text_input.dart';
import 'login_screen.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final ClientViewModel _clientViewModel = ClientViewModel();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                kSizedBoxHeight_50,
                Image.asset(
                  'assets/images/consultation_app_logo.png',
                  width: 150.0,
                ),
                kSizedBoxHeight_15,
                const Text(
                  'Welcome to CA',
                  style: kHeadlineTextStyle,
                ),
                kSizedBoxHeight_30,
                TextInput(
                  controller: _nameController,
                  hint: 'Name',
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                kSizedBoxHeight_15,
                TextInput(
                  controller: _companyNameController,
                  hint: 'Company Name',
                ),
                kSizedBoxHeight_15,
                TextInput(
                  controller: _emailController,
                  hint: 'Email address',
                  isEmail: true,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Email address is required';
                    }
                    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(val)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                kSizedBoxHeight_15,
                TextInput(
                  controller: _passwordController,
                  hint: 'Password',
                  isPassword: true,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Password is required';
                    }
                    if (val.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                kSizedBoxHeight_30,
                CustomButton(
                  title: 'Sign Up',
                  onPressed: () => _signUp(context),
                ),
                kSizedBoxHeight_40,
                BottomLink(
                  text: 'Already have an account? ',
                  linkText: 'Login',
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
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

  void _signUp(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      LoadingProgressIndicator.showProgressIndicator(context);

      Client client = Client(
        name: _nameController.text.trim(),
        companyName: _companyNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      _clientViewModel.registerClient(context, client);
    }
  }
}
