import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reused_flutter/models/tuple.dart';
import 'package:reused_flutter/screens/chat/chat_screen.dart';

import '../../providers/auth_provider.dart';

class ChatsMainScreen extends StatelessWidget {
  static const routeName = "/chats";
  ChatsMainScreen({Key? key}) : super(key: key);

  var _shouldReloadUserData = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
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
          itemBuilder: (context, index) => Container(
            height: 70,
            child: ChatCard(
                authProvider.getUserDataByID(_chatList[index].first).username,
                _chatList[index].first,
                "first"),
          ),
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
  final String lastMessage;
  const ChatCard(this.username, this.id, this.lastMessage, {Key? key})
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
