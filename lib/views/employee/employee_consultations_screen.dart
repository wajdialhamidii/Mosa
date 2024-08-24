import 'package:consultation_app/services/auth_service.dart';
import 'package:consultation_app/utils/formatting_utils.dart';
import 'package:consultation_app/view_models/auth_view_model.dart';
import 'package:consultation_app/view_models/consultation_view_model.dart';
import 'package:consultation_app/views/employee/employee_chat_screen.dart';
import 'package:consultation_app/widgets/loading_progress_indicator.dart';
import 'package:consultation_app/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';
import '../../utils/message_dialog_util.dart';

class EmployeeConsultationScreen extends StatefulWidget {
  const EmployeeConsultationScreen({super.key});

  @override
  State<EmployeeConsultationScreen> createState() =>
      _EmployeeConsultationScreenState();
}

class _EmployeeConsultationScreenState
    extends State<EmployeeConsultationScreen> {
  late Future<void> _fetchConsultationsFuture;
  late int? employeeId;

  @override
  void initState() {
    super.initState();
    _fetchConsultationsFuture = _loadConsultations();
  }

  Future<void> _loadConsultations() async {
    employeeId = await AuthService().getUserId();
    final consultationViewModel =
        Provider.of<ConsultationViewModel>(context, listen: false);
    if (employeeId != null) {
      await consultationViewModel.fetchEmployeeConsultations(employeeId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final consultationViewModel = Provider.of<ConsultationViewModel>(context);

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        centerTitle: true,
        title: const Text(
          'Consultations',
          style: kScreenTitleTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: () {
              MessageDialogUtil.showQuestionDialog(
                context: context,
                title: 'Logout',
                message: 'Are you sure you want to logout?',
                okButton: () {
                  AuthViewModel().logout(context);
                },
                cancelButton: () {
                  Navigator.pop(context);
                },
              );
            },
            tooltip: 'Logout',
            icon: const Icon(
              Icons.logout,
              color: kRedColor,
            ),
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _fetchConsultationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
              'Error: ${snapshot.error}',
              style: kGreyedOutTextStyle,
            ));
          } else {
            return consultationViewModel.isLoading
                ? const Center(child: LoadingProgressIndicator())
                : consultationViewModel.getConsultations.isEmpty
                    ? const Center(
                        child: Text(
                        'No consultations yet!',
                        style: kGreyedOutTextStyle,
                      ))
                    : RefreshIndicator(
                        color: kMainColor,
                        backgroundColor: kBackgroundColor,
                        onRefresh: () async {
                          consultationViewModel
                              .fetchEmployeeConsultations(employeeId!);
                        },
                        child: ListView.builder(
                          itemCount:
                              consultationViewModel.getConsultations.length,
                          itemBuilder: (context, index) {
                            final consultation =
                                consultationViewModel.getConsultations[index];
                            bool status = consultation.status == 0;
                            return UserCard(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EmployeeChatScreen(
                                      chatTitle: consultation.title.toString(),
                                      consultationId:
                                          consultation.id.toString(),
                                      clientId: consultation.clientId!,
                                      employeeId: consultation.employeeId!,
                                      status: consultation.status!,
                                    ),
                                  ),
                                );
                              },
                              title: consultation.title!,
                              imageUrl: 'assets/images/avatar.png',
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Started: ${FormattingUtils.formatDateTime(consultation.startTime!)}',
                                    style: kUserCardTimeTextStyle,
                                  ),
                                  status
                                      ? const SizedBox()
                                      : Text(
                                          'Concluded: ${FormattingUtils.formatDateTime(consultation.endTime!)}',
                                          style: kUserCardTimeTextStyle,
                                        ),
                                ],
                              ),
                              tagText: status ? 'Ongoing' : 'Concluded',
                              tagColor: status ? kLightBlueColor : kGreenColor,
                            );
                          },
                        ),
                      );
          }
        },
      ),
    );
  }
}
