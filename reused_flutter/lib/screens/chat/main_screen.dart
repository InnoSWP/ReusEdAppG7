import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reused_flutter/models/chat_message_model.dart';
import 'package:reused_flutter/models/tuple.dart';
import 'package:reused_flutter/providers/auth_provider.dart';
import 'package:reused_flutter/providers/chat_provider.dart';
import 'package:reused_flutter/screens/chat/chat_screen.dart';

class ChatsMainScreen extends StatefulWidget {
  static const routeName = "/chats";
  const ChatsMainScreen({Key? key}) : super(key: key);

  @override
  State<ChatsMainScreen> createState() => _ChatsMainScreenState();
}

class _ChatsMainScreenState extends State<ChatsMainScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    print('rebuilt');
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(authProvider.currentUserAuthData.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        var data = snapshot.data!.data() as Map<String, dynamic>;
        List<Tuple<String, Map<String, dynamic>>> chatList = [];
        (data["chats"] as Map).forEach(
          (key, value) {
            chatList.add(Tuple(key, value));
          },
        );
        chatList.sort(
          (a, b) {
            int firstTime = (a.second["lastTimestamp"] as Timestamp).millisecondsSinceEpoch;
            int secondTime = (b.second["lastTimestamp"] as Timestamp).millisecondsSinceEpoch;
            return secondTime.compareTo(firstTime);
          },
        );
        return ListView.builder(
          itemBuilder: (context, index) {
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatList[index].second["id"])
                  .snapshots(),
              builder: (context, messageSnapshot) {
                if (!messageSnapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final Map lastMessageMap = (messageSnapshot.data!.data() as Map)["messages"].last;
                final lastMessage = ChatMessageModel(
                  message: lastMessageMap["message"],
                  timestamp: (lastMessageMap["timestamp"] as Timestamp).millisecondsSinceEpoch,
                  senderName: '',
                  senderId: lastMessageMap["sender"],
                );
                return ChatCard(
                  authProvider.getUserDataByID(chatList[index].first).username,
                  chatList[index].first,
                  lastMessage,
                  authProvider,
                );
              },
            );
          },
          itemCount: chatList.length,
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
    var senderUsername =
        provider.getUserDataByID(lastMessage.senderId).username;
    return Card(
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(
          UserChatScreen.routeName,
          arguments: {"id": id},
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.shade200,
                  ),
                ),
              ),
              Flexible(
                flex: 6,
                fit: FlexFit.tight,
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
                          DateFormat('HH:mm').format(
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
                          '${(senderUsername == username) ? '' : 'You'}:',
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
            ],
          ),
        ),
      ),
    );
  }
}
