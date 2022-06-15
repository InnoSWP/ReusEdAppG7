import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class DiscussionProvider extends ChangeNotifier {
  DiscussionProvider();

  void createNewDiscussion(String discussionTitle) async {
    final String discussionId = const Uuid().v1();
    var discussionsInstance =
        FirebaseFirestore.instance.collection('discussions');
    var authorId = FirebaseAuth.instance.currentUser!.uid;
    final currentTime = Timestamp.fromDate(DateTime.now());

    await discussionsInstance.doc(discussionId).set(
      {
        'title': discussionTitle,
        'author': authorId,
        'creationTime': currentTime.millisecondsSinceEpoch,
        'comments': [],
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
            "timestamp":
                Timestamp.fromDate(DateTime.now()).millisecondsSinceEpoch,
            "comment": comment,
          },
        ]),
      },
      SetOptions(merge: true),
    );
  }
}
