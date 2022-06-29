import '../../main/models/user_model.dart';
import 'discussion_comment_model.dart';

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
