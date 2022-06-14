import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reused_flutter/models/chat_message_model.dart';
import 'package:reused_flutter/models/tuple.dart';
import 'package:reused_flutter/providers/chat_provider.dart';
import 'package:reused_flutter/screens/chat/chat_screen.dart';

import '../../providers/auth_provider.dart';

class ChatsMainScreen extends StatelessWidget {
  static const routeName = "/chats";
  ChatsMainScreen({Key? key}) : super(key: key);

  var _shouldReloadUserData = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    final _chatMap = authProvider.currentUserData.chats;
    final List<Tuple<String, String>> _chatList = [];
    // print(_chatList);
    _chatMap.forEach(
      (key, value) {
        authProvider.initUserDataByID(key);
        _chatList.add(Tuple(key, value));
      },
    );
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(authProvider.currentUserAuthData.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          _shouldReloadUserData = true;
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (_shouldReloadUserData) {
          authProvider.reloadCurrentUserInfo();
          print(authProvider.currentUserData.chats);
          _shouldReloadUserData = false;
        }
        //   await FirebaseFirestore.instance
        // .collection('users')
        // .doc(user.currentUser!.uid)
        // .get()
        // .then((value) => _currentUserData = value.data()!);
        return ListView.separated(
          itemBuilder: (context, index) {
            chatProvider.getLastMessage(_chatList[index].second);
            return Container(
              height: 70,
              child: ChatCard(
                authProvider.getUserDataByID(_chatList[index].first).username,
                _chatList[index].first,
                chatProvider.getLastMessage(_chatList[index].second),
                authProvider,
              ),
            );
          },
          separatorBuilder: (_, __) => const Divider(),
          itemCount: _chatList.length,
        );
      },
    );
  }
}

class ChatCard extends StatelessWidget {
  final String username;
  final String id;
  final ChatMessageModel lastMessage;
  final AuthProvider provider;
  const ChatCard(this.username, this.id, this.lastMessage, this.provider,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        UserChatScreen.routeName,
        arguments: {"id": id},
      ),
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    DateFormat('HH:MM').format(
                      DateTime.fromMillisecondsSinceEpoch(
                          lastMessage.timestamp),
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    provider.getUserDataByID(lastMessage.senderId).username +
                        ':',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    lastMessage.message,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
