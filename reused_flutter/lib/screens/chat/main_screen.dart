import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reused_flutter/models/tuple.dart';
import 'package:reused_flutter/screens/chat/chat_screen.dart';

import '../../providers/auth_provider.dart';

class ChatsMainScreen extends StatelessWidget {
  static const routeName = "/chats";
  const ChatsMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final _chatMap = authProvider.currentUserData.chats;
    final List<Tuple<String, String>> _chatList = [];
    // print(_chatList);
    _chatMap.forEach(
      (key, value) {
        authProvider.initUserDataByID(key);
        _chatList.add(Tuple(key, value));
      },
    );
    return ListView.separated(
      itemBuilder: (context, index) => Container(
        height: 70,
        // child:
            // Text(authProvider.getUserDataByID(_chatList[index].first).username),
        child: ChatCard(authProvider.getUserDataByID(_chatList[index].first).username, "first"),
      ),
      separatorBuilder: (_, __) => const Divider(),
      itemCount: 1,
    );
  }
}

class ChatCard extends StatelessWidget {
  final String username;
  final String lastMessage;
  const ChatCard(this.username, this.lastMessage, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, UserChatScreen.routeName,
          arguments: {"username": username}),
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        height: 75,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Text(username),
              Text(lastMessage),
            ],
          ),
        ),
      ),
    );
  }
}
