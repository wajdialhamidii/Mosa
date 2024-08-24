import 'package:consultation_app/utils/constants.dart';
import 'package:consultation_app/utils/sizes.dart';
import 'package:consultation_app/view_models/client_view_model.dart';
import 'package:consultation_app/widgets/loading_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/chat_message.dart';
import '../../view_models/chat_view_model.dart';
import '../../widgets/message_bubble.dart';

class AdminEmployeeChatScreen extends StatefulWidget {
  final String consultationId;
  final int clientId;
  final int employeeId;
  final String chatTitle;
  final int status;

  const AdminEmployeeChatScreen({
    super.key,
    required this.consultationId,
    required this.clientId,
    required this.employeeId,
    required this.chatTitle,
    required this.status,
  });

  @override
  State<AdminEmployeeChatScreen> createState() =>
      _AdminEmployeeChatScreenState();
}

class _AdminEmployeeChatScreenState extends State<AdminEmployeeChatScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final clientViewModel =
          Provider.of<ClientViewModel>(context, listen: false);
      clientViewModel.getClientData(widget.clientId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatViewModel = Provider.of<ChatViewModel>(context);
    final bool isCompleted = widget.status == 1;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        title: Consumer<ClientViewModel>(
          builder: (context, clientViewModel, child) {
            final client = clientViewModel.getClient;
            final clientName = client?.name ?? 'Loading...';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.chatTitle),
                Text(
                  clientName,
                  style: kGreyedOutTextStyle,
                ),
              ],
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: chatViewModel.getChatMessages(widget.consultationId),
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
                      isSentCurrentUser: message.senderId == widget.employeeId,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isCompleted
                      ? 'This consultation has been concluded.'
                      : 'You cannot participate in this chat.',
                  style: kGreyedOutTextStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
