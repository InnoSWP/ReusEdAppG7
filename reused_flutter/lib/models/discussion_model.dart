import 'package:reused_flutter/models/discussion_comment_model.dart';
import 'package:reused_flutter/models/user_model.dart';

class DiscussionModel {
  final UserModel author;
  final String title;
  final List<DiscussionCommentModel> comments;
  DiscussionModel({
    required this.author,
    required this.title,
    required this.comments,
  });
}
