import 'package:consultation_app/utils/constants.dart';
import 'package:consultation_app/widgets/loading_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        authViewModel.checkLoginStatus(context);
      });
    });

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              'assets/images/consultation_app_logo.png',
              width: 150.0,
            ),
            const LoadingProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
