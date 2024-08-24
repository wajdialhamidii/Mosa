import 'package:consultation_app/services/auth_service.dart';
import 'package:consultation_app/utils/formatting_utils.dart';
import 'package:consultation_app/utils/snackbar_util.dart';
import 'package:consultation_app/view_models/consultation_view_model.dart';
import 'package:consultation_app/views/client/client_categories_screen.dart';
import 'package:consultation_app/views/client/client_chat_screen.dart';
import 'package:consultation_app/views/client/update_client_screen.dart';
import 'package:consultation_app/widgets/loading_progress_indicator.dart';
import 'package:consultation_app/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';
import '../../utils/message_dialog_util.dart';

class ClientConsultationScreen extends StatefulWidget {
  const ClientConsultationScreen({super.key});

  @override
  State<ClientConsultationScreen> createState() =>
      _ClientConsultationScreenState();
}

class _ClientConsultationScreenState extends State<ClientConsultationScreen> {
  late Future<void> _fetchConsultationsFuture;
  late int? clientId;

  @override
  void initState() {
    super.initState();
    _fetchConsultationsFuture = _loadConsultations();
  }

  Future<void> _loadConsultations() async {
    clientId = await AuthService().getUserId();
    final consultationViewModel =
        Provider.of<ConsultationViewModel>(context, listen: false);
    if (clientId != null) {
      await consultationViewModel.fetchClientConsultations(clientId!);
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UpdateClientScreen()));
            },
            tooltip: 'Settings',
            icon: CircleAvatar(
              backgroundColor: kGreyShade400Color,
              child: Image.asset(
                'assets/images/avatar.png',
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kMainColor,
        tooltip: 'New Consultation',
        onPressed: () async {
          Navigator.push(
              (context),
              MaterialPageRoute(
                  builder: (context) => const ClientCategoriesScreen()));
        },
        child: const Icon(
          Icons.add,
          size: 25.0,
          color: kWhiteColor,
        ),
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
                              .fetchClientConsultations(clientId!);
                        },
                        child: ListView.builder(
                          itemCount:
                              consultationViewModel.getConsultations.length,
                          itemBuilder: (context, index) {
                            final consultation =
                                consultationViewModel.getConsultations[index];
                            bool isCompleted = consultation.status == 1;
                            return UserCard(
                              onLongPress: () {
                                if (isCompleted) {
                                  MessageDialogUtil.showQuestionDialog(
                                    context: context,
                                    title: 'Delete',
                                    message:
                                        'Are you sure you want to delete this consultation?',
                                    okButton: () async {
                                      Navigator.pop(context);
                                      try {
                                        await consultationViewModel
                                            .deleteConsultation(
                                          consultation.id!,
                                          consultation.clientId!,
                                        );

                                        SnackbarUtil.showSnackbar(
                                          context,
                                          'Consultation successfully delete.',
                                          kMainColor,
                                        );
                                      } catch (e) {
                                        SnackbarUtil.showSnackbar(
                                          context,
                                          'Failed to delete consultation.',
                                          kRedColor,
                                        );
                                      }
                                    },
                                    cancelButton: () {
                                      Navigator.pop(context);
                                    },
                                  );
                                } else {
                                  SnackbarUtil.showSnackbar(
                                    context,
                                    'Cannot delete Ongoing consultation.',
                                    kRedColor,
                                  );
                                }
                              },
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ClientChatScreen(
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
                                  if (isCompleted)
                                    Text(
                                      'Concluded: ${FormattingUtils.formatDateTime(consultation.endTime!)}',
                                      style: kUserCardTimeTextStyle,
                                    ),
                                ],
                              ),
                              tagText: isCompleted ? 'Concluded' : 'Ongoing',
                              tagColor:
                                  isCompleted ? kGreenColor : kLightBlueColor,
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
