import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reused_flutter/models/chat_message_model.dart';
import 'package:reused_flutter/providers/auth_provider.dart';
import 'package:reused_flutter/providers/chat_provider.dart';

class UserChatScreen extends StatefulWidget {
  static const routeName = "/user_chat";
  const UserChatScreen({Key? key}) : super(key: key);

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  bool _hasMessages = false;
  bool _isSendButtonActive = false;
  final _messageController = TextEditingController();
  final _textFocusNode = FocusNode();

  void _sendMessage(String id) async {
    // do something
    var fireInstance = FirebaseFirestore.instance.collection('chats');
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final userInfoProvider = Provider.of<AuthProvider>(context, listen: false);
    final Map<String, dynamic> chats = userInfoProvider.currentUserData.chats;
    final currentUsername = userInfoProvider.currentUserData.username;
    if (!chats.containsKey(id)) {
      chatProvider.createNewChat(currentUsername, id, _messageController.text);
    } else {
      chatProvider.sendMessage(
        chats[id]["id"],
        userInfoProvider.currentUserData.id,
        id,
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
    final String recipientId = routeArgs['id']!;
    final authProvider = Provider.of<AuthProvider>(context);
    final recipientData = authProvider.getUserDataByID(recipientId);
    final String? chatId = authProvider.currentUserData.chats[recipientId]?["id"];
    if (chatId != null) {
      _hasMessages = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(recipientData.username),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _textFocusNode.unfocus(),
              behavior: HitTestBehavior.translucent,
              child: _hasMessages
                  ? StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("chats")
                          .doc(chatId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        List<ChatMessageModel> _messages = [];
                        for (var value in ((snapshot.data!.data()
                            as Map)["messages"] as List)) {
                          _messages.add(
                            ChatMessageModel(
                              message: value["message"],
                              timestamp: (value["timestamp"] as Timestamp)
                                  .millisecondsSinceEpoch,
                              senderId: value["sender"],
                              senderName: authProvider.currentUserData.username,
                            ),
                          );
                        }
                        return ListView.builder(
                          itemBuilder: (context, index) =>
                              MessageCard(_messages[index]),
                          itemCount: _messages.length,
                        );
                      },
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
                            _isSendButtonActive = true;
                          });
                        } else {
                          setState(() {
                            _isSendButtonActive = false;
                          });
                        }
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _isSendButtonActive
                      ? null
                      : () => _sendMessage(recipientId),
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

class MessageCard extends StatelessWidget {
  final ChatMessageModel message;
  const MessageCard(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(message.senderName),
              const SizedBox(width: 10),
              Text(
                DateFormat('HH:mm').format(
                  DateTime.fromMillisecondsSinceEpoch(message.timestamp),
                ),
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            message.message,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
