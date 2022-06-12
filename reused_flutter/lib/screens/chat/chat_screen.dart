import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reused_flutter/providers/auth_provider.dart';
import 'package:reused_flutter/providers/chat_provider.dart';

class UserChatScreen extends StatefulWidget {
  static const routeName = "/user_chat";
  const UserChatScreen({Key? key}) : super(key: key);

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  final bool _hasMessages = false;
  bool _isSendButtonActive = false;
  final _messageController = TextEditingController();
  final _textFocusNode = FocusNode();

  void _sendMessage(String username) async {
    // do something
    // var firebaseSnapshot =
    //     await FirebaseFirestore.instance.collection('chats').get();
    // final listOfChats = firebaseSnapshot.docs.map((doc) => doc.id).toList();
    // if (listOfChats.contains(element))
    var fireInstance = FirebaseFirestore.instance.collection('chats');
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final userInfoProvider = Provider.of<AuthProvider>(context, listen: false);
    final Map<String, dynamic> chats = userInfoProvider.currentUserData.chats;
    final currentUsername = userInfoProvider.currentUserData.username;
    if (!chats.containsKey(username)) {
      chatProvider.createNewChat(
          currentUsername, username, _messageController.text);
    } else {
      chatProvider.sendMessage(
        chats[username],
        userInfoProvider.currentUserData.id,
        _messageController.text,
      );
    }
    setState(() {
      _messageController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String username = routeArgs['username']!;
    print('here ' + username);
    return Scaffold(
      appBar: AppBar(
        title: Text(username),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _textFocusNode.unfocus(),
              behavior: HitTestBehavior.translucent,
              child: _hasMessages
                  ? SingleChildScrollView(
                      child: Container(),
                      // have messages here, listview builder, i guess
                    )
                  : const Center(child: Text('No messages here yet!')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _textFocusNode.attach(context),
                    child: TextField(
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Enter your message...',
                        focusColor: null,
                        filled: false,
                      ),
                      maxLines: 10,
                      minLines: 1,
                      controller: _messageController,
                      focusNode: _textFocusNode,
                      autofocus: true,
                      keyboardType: TextInputType.multiline,
                      // onSubmitted: null,
                      onChanged: (_) {
                        if (_messageController.text.isEmpty) {
                          setState(() {
                            _isSendButtonActive = false;
                          });
                        } else {
                          setState(() {
                            _isSendButtonActive = true;
                          });
                        }
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed:
                      _isSendButtonActive ? null : () => _sendMessage(username),
                  child: const Text("Send"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
