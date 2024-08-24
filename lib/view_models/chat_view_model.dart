import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/chat_service.dart';

class ChatViewModel extends ChangeNotifier {
  final ChatService _chatService = ChatService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Stream<List<ChatMessage>> getChatMessages(String consultationId) {
    return _chatService.getChatMessages(consultationId);
  }

  Future<void> sendMessage(String consultationId, ChatMessage message) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _chatService.sendMessage(consultationId, message);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
