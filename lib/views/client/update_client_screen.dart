import 'package:consultation_app/services/auth_service.dart';
import 'package:consultation_app/utils/constants.dart';
import 'package:consultation_app/utils/snackbar_util.dart';
import 'package:consultation_app/widgets/loading_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/client.dart';
import '../../utils/message_dialog_util.dart';
import '../../utils/sizes.dart';
import '../../view_models/auth_view_model.dart';
import '../../view_models/client_view_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/text_input.dart';

class UpdateClientScreen extends StatefulWidget {
  const UpdateClientScreen({super.key});

  @override
  State<UpdateClientScreen> createState() => _UpdateClientScreenState();
}

class _UpdateClientScreenState extends State<UpdateClientScreen> {
  late ClientViewModel _clientViewModel;
  late int clientId;

  @override
  void initState() {
    super.initState();
    _clientViewModel = Provider.of<ClientViewModel>(context, listen: false);
    _initializeClientData();
  }

  Future<void> _initializeClientData() async {
    clientId = (await AuthService().getUserId())!;
    _clientViewModel.getClientData(clientId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientViewModel>(
      builder: (context, clientViewModel, child) {
        if (clientViewModel.getClient == null) {
          return const Scaffold(
              backgroundColor: kBackgroundColor,
              body: Center(child: LoadingProgressIndicator()));
        } else {
          return _buildForm(clientViewModel.getClient!);
        }
      },
    );
  }

  Widget _buildForm(Client client) {
    TextEditingController nameController =
        TextEditingController(text: client.name);
    TextEditingController passwordController =
        TextEditingController(text: client.password);
    TextEditingController companyNameController =
        TextEditingController(text: client.companyName);
    TextEditingController emailController =
        TextEditingController(text: client.email);
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
                controller: companyNameController,
                hint: 'Company Name',
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
                  await _updateClient(
                      formKey,
                      nameController,
                      companyNameController,
                      emailController,
                      passwordController);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateClient(
      GlobalKey<FormState> formKey,
      TextEditingController nameController,
      TextEditingController companyNameController,
      TextEditingController emailController,
      TextEditingController passwordController) async {
    if (formKey.currentState!.validate()) {
      LoadingProgressIndicator.showProgressIndicator(context);
      try {
        Client updatedClient = Client(
          id: clientId,
          name: nameController.text.trim(),
          companyName: companyNameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        await _clientViewModel.updateClient(updatedClient);
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
