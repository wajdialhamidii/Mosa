import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ChatMessage>> getChatMessages(String consultationId) {
    return _firestore
        .collection('chats')
        .doc(consultationId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromJson(doc.data()))
            .toList());
  }

  Future<void> sendMessage(String consultationId, ChatMessage message) async {
    await _firestore
        .collection('chats')
        .doc(consultationId)
        .collection('messages')
        .add(message.toJson());
  }
}
