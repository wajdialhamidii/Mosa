import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../utils/constants.dart';
import '../utils/formatting_utils.dart';
import '../utils/sizes.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isSentCurrentUser;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isSentCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          isSentCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isSentCurrentUser ? kMainColor : const Color(0xffEEF7FF),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: TextStyle(
                fontSize: 16.0,
                color: isSentCurrentUser ? kWhiteColor : Colors.black,
              ),
            ),
            kSizedBoxHeight_5,
            Text(
              FormattingUtils.formatDateTime(message.timestamp),
              style: TextStyle(
                color: isSentCurrentUser ? Colors.white70 : Colors.black54,
                fontSize: 10.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
