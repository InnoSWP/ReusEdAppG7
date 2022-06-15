import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class DiscussionProvider extends ChangeNotifier {
  DiscussionProvider();

  void getDiscussionByID(String discussion_id) {}

  void createNewDiscussion(String discussionTitle, String newComment) async {
    final String discussionId = const Uuid().v1();
    var discussionsInstance =
        FirebaseFirestore.instance.collection('discussions');
    var authorId = FirebaseAuth.instance.currentUser!.uid;
    final currentTime = Timestamp.fromDate(DateTime.now());

    await discussionsInstance.doc(discussionId).set(
      {
        'title': discussionTitle,
        'author': authorId,
        'comments': [
          {
            "sender": authorId,
            "timestamp": currentTime,
            "comment": newComment,
          },
        ],
      },
    );
  }

  void leaveComment(
      String discussionId, String senderId, String comment) async {
    var discussionsInstance =
        FirebaseFirestore.instance.collection('discussions');
    await discussionsInstance.doc(discussionId).set(
      {
        'comments': FieldValue.arrayUnion([
          {
            "sender": senderId,
            "timestamp": Timestamp.fromDate(DateTime.now()),
            "comment": comment,
          },
        ]),
      },
      SetOptions(merge: true),
    );
  }
}
