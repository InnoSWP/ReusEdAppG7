import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reused_flutter/providers/auth_provider.dart';

class ChatsMainScreen extends StatelessWidget {
  static const routeName = "/chats";
  const ChatsMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _userData =
        Provider.of<AuthProvider>(context).getAuthInfo().currentUser;
    return Container();
  }
}

class ChatCard extends StatelessWidget {
  const ChatCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
