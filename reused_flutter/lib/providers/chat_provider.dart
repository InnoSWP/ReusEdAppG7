import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class ChatProvider extends ChangeNotifier {
  ChatProvider();

  void createNewChat(String sender, String recipient, String newMessage) async {
    final String chatsId = const Uuid().v1();
    var usersInstance = FirebaseFirestore.instance.collection('users');
    var chatsInstance = FirebaseFirestore.instance.collection('chats');
    var senderId = FirebaseAuth.instance.currentUser!.uid;
    var recipientData =
        await usersInstance.where('username', isEqualTo: recipient).get();
    var recipientId = recipientData.docs.map((doc) => doc.id).first;
    await chatsInstance.doc(chatsId).set(
      {
        'user1': senderId,
        'user2': recipientId,
        'messages': {
          Timestamp.fromDate(DateTime.now()).toString(): {
            "sender": senderId,
            "timestamp": Timestamp.fromDate(DateTime.now()),
            "message": newMessage,
          },
        },
      },
    );
    await usersInstance.doc(senderId).update({"chats.$recipientId": chatsId});
    await usersInstance.doc(recipientId).update({"chats.$senderId": chatsId});
  }

  void sendMessage(String chatId, String senderId, String message) async {
    var chatsInstance = FirebaseFirestore.instance.collection('chats');
    await chatsInstance.doc(chatId).update({
      'messages.${Timestamp.fromDate(DateTime.now()).toString()}': {
        "sender": senderId,
        "timestamp": Timestamp.fromDate(DateTime.now()),
        "message": message,
      },
    });
  }
}
