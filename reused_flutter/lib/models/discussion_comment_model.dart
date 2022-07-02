import 'package:reused_flutter/models/user_model.dart';

class DiscussionCommentModel {
  final String comment;
  final int timestamp;
  final UserModel sender;
  final String discussionId;
  DiscussionCommentModel({
    required this.comment,
    required this.timestamp,
    required this.sender,
    required this.discussionId,
  });
}
