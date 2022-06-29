import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class ChatProvider extends ChangeNotifier {
  ChatProvider();

  void createNewChat(
      String sender, String recipientId, String newMessage) async {
    final String chatsId = const Uuid().v1();
    var usersInstance = FirebaseFirestore.instance.collection('users');
    var chatsInstance = FirebaseFirestore.instance.collection('chats');
    var senderId = FirebaseAuth.instance.currentUser!.uid;
    final currentTime = Timestamp.fromDate(DateTime.now());
    await chatsInstance.doc(chatsId).set(
      {
        'user1': senderId,
        'user2': recipientId,
        'messages': [
          {
            "sender": senderId,
            "timestamp": currentTime,
            "message": newMessage,
          },
        ],
      },
    );
    await usersInstance.doc(senderId).update(
      {
        "chats.$recipientId": {
          "id": chatsId,
          "lastTimestamp": currentTime,
        },
      },
    );
    await usersInstance.doc(recipientId).update(
      {
        "chats.$senderId": {
          "id": chatsId,
          "lastTimestamp": currentTime,
        },
      },
    );
  }

  void sendMessage(String chatId, String senderId, String recipientId, String message) async {
    var usersInstance = FirebaseFirestore.instance.collection('users');
    var chatsInstance = FirebaseFirestore.instance.collection('chats');
    final currentTime = Timestamp.fromDate(DateTime.now());
    await chatsInstance.doc(chatId).set(
      {
        'messages': FieldValue.arrayUnion([
          {
            "sender": senderId,
            "timestamp": currentTime,
            "message": message,
          },
        ]),
      },
      SetOptions(merge: true),
    );
    await usersInstance.doc(senderId).update(
      {
        "chats.$recipientId": {
          "id": chatId,
          "lastTimestamp": currentTime,
        },
      },
    );
    await usersInstance.doc(recipientId).update(
      {
        "chats.$senderId": {
          "id": chatId,
          "lastTimestamp": currentTime,
        },
      },
    );
  }
}
