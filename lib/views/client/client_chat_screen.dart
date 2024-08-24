import 'package:consultation_app/models/consultation.dart';
import 'package:consultation_app/models/rating.dart';
import 'package:consultation_app/utils/constants.dart';
import 'package:consultation_app/utils/message_dialog_util.dart';
import 'package:consultation_app/utils/sizes.dart';
import 'package:consultation_app/utils/snackbar_util.dart';
import 'package:consultation_app/view_models/consultation_view_model.dart';
import 'package:consultation_app/view_models/employee_view_model.dart';
import 'package:consultation_app/view_models/rating_view_model.dart';
import 'package:consultation_app/widgets/loading_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/chat_message.dart';
import '../../view_models/chat_view_model.dart';
import '../../widgets/message_bubble.dart';

class ClientChatScreen extends StatefulWidget {
  final String consultationId;
  final int clientId;
  final int employeeId;
  final String chatTitle;
  final int status;

  const ClientChatScreen({
    super.key,
    required this.consultationId,
    required this.clientId,
    required this.employeeId,
    required this.chatTitle,
    required this.status,
  });

  @override
  State<ClientChatScreen> createState() => _ClientChatScreenState();
}

class _ClientChatScreenState extends State<ClientChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final employeeViewModel =
          Provider.of<EmployeeViewModel>(context, listen: false);
      employeeViewModel.getEmployeeData(widget.employeeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatViewModel = Provider.of<ChatViewModel>(context);
    final bool isCompleted = widget.status == 0;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        title: Consumer<EmployeeViewModel>(
          builder: (context, viewModel, child) {
            final employee = viewModel.getEmployee;
            final employeeName = employee?.name ?? 'Loading...';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.chatTitle),
                Text(
                  employeeName,
                  style: kGreyedOutTextStyle,
                ),
              ],
            );
          },
        ),
        actions: [
          if (isCompleted)
            IconButton(
              onPressed: _endConsultation,
              icon: const Icon(
                Icons.check_circle_outlined,
                size: 30.0,
                color: kGreenColor,
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: chatViewModel
                  .getChatMessages(widget.consultationId.toString()),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                      child: Text(
                    'Error loading messages',
                    style: kGreyedOutTextStyle,
                  ));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: LoadingProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No messages yet.',
                      style: kGreyedOutTextStyle,
                    ),
                  );
                }
                final messages = snapshot.data!;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return MessageBubble(
                      message: message,
                      isSentCurrentUser: message.senderId == widget.clientId,
                    );
                  },
                );
              },
            ),
          ),
          kSizedBoxHeight_10,
          Container(
            padding: const EdgeInsets.all(8.0),
            color: kWhiteColor,
            child: isCompleted
                ? Row(
                    children: [
                      Expanded(
                        child: TextField(
                          minLines: 1,
                          maxLines: 3,
                          controller: _messageController,
                          cursorColor: kBlackColor,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                            hintText: 'Type a message',
                            hintStyle: kGreyedOutTextStyle,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: kMainColor,
                          size: 30.0,
                        ),
                        onPressed: () async {
                          if (_messageController.text.trim().isEmpty) return;

                          final newMessage = ChatMessage(
                            senderId: widget.clientId,
                            message: _messageController.text.trim(),
                            timestamp: DateTime.now(),
                            receiverId: widget.employeeId,
                          );

                          await chatViewModel.sendMessage(
                            widget.consultationId.toString(),
                            newMessage,
                          );

                          _messageController.clear();
                        },
                      ),
                    ],
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'This consultation has been concluded.',
                        style: kGreyedOutTextStyle,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  void _endConsultation() async {
    MessageDialogUtil.showQuestionDialog(
      context: context,
      title: 'End Consultation',
      message: 'Are you sure you want to end this consultation?',
      okButton: () async {
        Navigator.pop(context);
        LoadingProgressIndicator.showProgressIndicator(context);
        try {
          Consultation consultation = Consultation.update(
            id: int.parse(widget.consultationId),
            endTime: DateTime.now(),
            status: 1,
          );

          await context.read<ConsultationViewModel>().updateConsultation(
                consultation,
                widget.clientId,
              );

          SnackbarUtil.showSnackbar(
            context,
            'Consultation status has been updated.',
            kMainColor,
          );

          double? ratingValue =
              await MessageDialogUtil.showRatingDialog(context);
          Rating rating = Rating(
            ratingValue: ratingValue ?? 0.0,
            time: DateTime.now(),
            clientId: widget.clientId,
            employeeId: widget.employeeId,
          );

          await context.read<RatingViewModel>().postRating(rating);

          Navigator.of(context).popUntil((route) => route.isFirst);
        } catch (e) {
          Navigator.pop(context);
          SnackbarUtil.showSnackbar(context, e.toString(), kRedColor);
        }
      },
      cancelButton: () {
        Navigator.pop(context);
      },
    );
  }
}
