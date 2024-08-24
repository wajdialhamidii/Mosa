import 'package:consultation_app/models/employee.dart';
import 'package:consultation_app/utils/formatting_utils.dart';
import 'package:consultation_app/view_models/consultation_view_model.dart';
import 'package:consultation_app/widgets/loading_progress_indicator.dart';
import 'package:consultation_app/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';
import 'admin_employee_chat_screen.dart';
import 'update_employee_screen.dart';

class AdminEmployeeConsultationsScreen extends StatefulWidget {
  const AdminEmployeeConsultationsScreen({super.key, required this.employee});
  final Employee employee;
  @override
  State<AdminEmployeeConsultationsScreen> createState() =>
      _AdminEmployeeConsultationsScreenState();
}

class _AdminEmployeeConsultationsScreenState
    extends State<AdminEmployeeConsultationsScreen> {
  late Future<void> _fetchConsultationsFuture;

  @override
  void initState() {
    super.initState();
    _fetchConsultationsFuture = _loadConsultations();
  }

  Future<void> _loadConsultations() async {
    final consultationViewModel =
        Provider.of<ConsultationViewModel>(context, listen: false);
    await consultationViewModel.fetchEmployeeConsultations(widget.employee.id!);
  }

  @override
  Widget build(BuildContext context) {
    final consultationViewModel = Provider.of<ConsultationViewModel>(context);

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        centerTitle: true,
        title: Text(
          widget.employee.name,
          style: kScreenTitleTextStyle,
        ),
        iconTheme: const IconThemeData(
          color: kWhiteColor,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UpdateEmployeeScreen(
                            employee: widget.employee,
                          )));
            },
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
              size: 25.0,
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
                              .fetchEmployeeConsultations(widget.employee.id!);
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
                                    builder: (context) =>
                                        AdminEmployeeChatScreen(
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
