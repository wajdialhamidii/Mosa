import 'package:consultation_app/models/super_admin.dart';
import 'package:consultation_app/services/auth_service.dart';
import 'package:consultation_app/utils/constants.dart';
import 'package:consultation_app/utils/snackbar_util.dart';
import 'package:consultation_app/view_models/admin_view_model.dart';
import 'package:consultation_app/widgets/loading_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/message_dialog_util.dart';
import '../../utils/sizes.dart';
import '../../view_models/auth_view_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/text_input.dart';

class UpdateAdminScreen extends StatefulWidget {
  const UpdateAdminScreen({super.key});

  @override
  State<UpdateAdminScreen> createState() => _UpdateAdminScreenState();
}

class _UpdateAdminScreenState extends State<UpdateAdminScreen> {
  late AdminViewModel _adminViewModel;
  late int adminId;

  @override
  void initState() {
    super.initState();
    _adminViewModel = Provider.of<AdminViewModel>(context, listen: false);
    _initializeAdminData();
  }

  Future<void> _initializeAdminData() async {
    adminId = (await AuthService().getUserId())!;
    _adminViewModel.getAdminData(adminId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminViewModel>(
      builder: (context, adminViewModel, child) {
        if (adminViewModel.getAdmin == null) {
          return const Scaffold(
              backgroundColor: kBackgroundColor,
              body: Center(child: LoadingProgressIndicator()));
        } else {
          return _buildForm(adminViewModel.getAdmin!);
        }
      },
    );
  }

  Widget _buildForm(SuperAdmin admin) {
    TextEditingController nameController =
        TextEditingController(text: admin.name);
    TextEditingController passwordController =
        TextEditingController(text: admin.password);

    TextEditingController emailController =
        TextEditingController(text: admin.email);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        centerTitle: true,
        title: const Text(
          'Settings',
          style: kScreenTitleTextStyle,
        ),
        iconTheme: const IconThemeData(color: kWhiteColor),
        actions: [
          IconButton(
            onPressed: () {
              final authViewModel =
                  Provider.of<AuthViewModel>(context, listen: false);
              MessageDialogUtil.showQuestionDialog(
                context: context,
                title: 'Logout',
                message: 'Are you sure you want to logout?',
                okButton: () {
                  authViewModel.logout(context);
                },
                cancelButton: () {
                  Navigator.pop(context);
                },
              );
            },
            icon: const Icon(
              Icons.logout,
              color: kLightRedColor,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              kSizedBoxHeight_30,
              TextInput(
                controller: nameController,
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
                controller: emailController,
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
                controller: passwordController,
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
                title: 'Save',
                onPressed: () async {
                  await _updateAdmin(formKey, nameController, emailController,
                      passwordController);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateAdmin(
      GlobalKey<FormState> formKey,
      TextEditingController nameController,
      TextEditingController emailController,
      TextEditingController passwordController) async {
    if (formKey.currentState!.validate()) {
      LoadingProgressIndicator.showProgressIndicator(context);
      try {
        SuperAdmin updatedAdmin = SuperAdmin(
          id: adminId,
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        await _adminViewModel.updateAdmin(updatedAdmin);
        SnackbarUtil.showSnackbar(
            context, 'Your data has been successfully updated.', kMainColor);

        Navigator.of(context).popUntil((route) => route.isFirst);
      } catch (e) {
        Navigator.pop(context);
        SnackbarUtil.showSnackbar(context, '$e', kRedColor);
      }
    }
  }
}
