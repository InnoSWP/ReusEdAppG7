class UserModel {
  final String id;
  final String username;
  final String email;
  final Map<String, dynamic> chats;
  final String role;
  UserModel({
    required this.id,
    required this.username,
    required this.chats,
    required this.email,
    required this.role,
  });
}
