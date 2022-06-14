import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:reused_flutter/models/chat_message_model.dart';
import 'package:uuid/uuid.dart';

class ChatProvider extends ChangeNotifier {
  final Map<String, ChatMessageModel> _lastMessages = {};
  ChatProvider();

  void createNewChat(
      String sender, String recipientId, String newMessage) async {
    final String chatsId = const Uuid().v1();
    var usersInstance = FirebaseFirestore.instance.collection('users');
    var chatsInstance = FirebaseFirestore.instance.collection('chats');
    var senderId = FirebaseAuth.instance.currentUser!.uid;
    await chatsInstance.doc(chatsId).set(
      {
        'user1': senderId,
        'user2': recipientId,
        'messages': [
          {
            "sender": senderId,
            "timestamp": Timestamp.fromDate(DateTime.now()),
            "message": newMessage,
          },
        ],
      },
    );
    await usersInstance.doc(senderId).update({"chats.$recipientId": chatsId});
    await usersInstance.doc(recipientId).update({"chats.$senderId": chatsId});
  }

  void sendMessage(String chatId, String senderId, String message) async {
    var chatsInstance = FirebaseFirestore.instance.collection('chats');
    await chatsInstance.doc(chatId).set(
      {
        'messages': FieldValue.arrayUnion([
          {
            "sender": senderId,
            "timestamp": Timestamp.fromDate(DateTime.now()),
            "message": message,
          },
        ]),
      },
      SetOptions(merge: true),
    );
  }

  void initLastMessage(String chatId) async {
    var chatsInstance = FirebaseFirestore.instance.collection('chats');
    var cock =
        await FirebaseFirestore.instance.collection("chats").doc(chatId).get();
    var message = (cock.data()!["messages"] as List).last;
    _lastMessages[chatId] = ChatMessageModel(
      message: message["message"],
      timestamp: (message["timestamp"] as Timestamp).millisecondsSinceEpoch,
      senderName: '',
      senderId: message["sender"],
    );
    notifyListeners();
  }

  ChatMessageModel getLastMessage(String chatId) {
    if (!_lastMessages.containsKey(chatId)) {
      initLastMessage(chatId);
      return ChatMessageModel(
        message: 'Loading...',
        timestamp: 0,
        senderName: '',
        senderId: '',
      );
    } else {
      return _lastMessages[chatId]!;
    }
  }
}
