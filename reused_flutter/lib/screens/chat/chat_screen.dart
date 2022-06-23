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
      _hasMessages = true;
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
    final String? chatId =
        authProvider.currentUserData.chats[recipientId]?["id"];
    print(chatId);
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
                        if (!snapshot.hasData ||
                            snapshot.data!.data() == null) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        List<ChatMessageModel> _messages = [];
                        print('data: ${snapshot.data!.data()}');
                        for (var value in ((snapshot.data!.data()
                            as Map)["messages"] as List)) {
                          _messages.add(
                            ChatMessageModel(
                              message: value["message"],
                              timestamp: (value["timestamp"] as Timestamp)
                                  .millisecondsSinceEpoch,
                              senderId: value["sender"],
                              senderName: authProvider.getUserDataByID(value["sender"]).username,
                            ),
                          );
                        }
                        return ListView.builder(
                          itemBuilder: (context, index) => MessageBubble(
                              _messages[index], authProvider.currentUserData.username),
                          itemCount: _messages.length,
                        );
                      },
                    )
                  : const Center(child: Text('No messages here yet!')),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.grey.shade100,
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
                        fillColor: Colors.blue,
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
                  onPressed: _isSendButtonActive
                      ? () => _sendMessage(recipientId)
                      : null,
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

class MessageBubble extends StatelessWidget {
  final String currentUser;
  final ChatMessageModel message;
  const MessageBubble(this.message, this.currentUser, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(message.senderName);
    return Row(
      mainAxisAlignment: (currentUser == message.senderName)
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: currentUser == message.senderName
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10),
                topRight: const Radius.circular(10),
                bottomLeft: Radius.circular(
                    (currentUser == message.senderName) ? 10 : 0),
                bottomRight: Radius.circular(
                    (currentUser == message.senderName) ? 0 : 10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 12, 12, 8),
              child: Column(
                crossAxisAlignment: (currentUser == message.senderName)
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    message.message,
                    style: TextStyle(
                      color: (currentUser == message.senderName)
                          ? Colors.white
                          : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    DateFormat("HH:mm").format(
                      DateTime.fromMillisecondsSinceEpoch(message.timestamp),
                    ),
                    style: TextStyle(
                      color: (currentUser == message.senderName)
                          ? Colors.grey.shade300
                          : Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
