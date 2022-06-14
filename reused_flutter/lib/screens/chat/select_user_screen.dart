import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reused_flutter/models/tuple.dart';
import 'package:reused_flutter/providers/auth_provider.dart';
import 'package:reused_flutter/screens/chat/chat_screen.dart';

class ChatSelectUserScreen extends StatefulWidget {
  static const routeName = "/chat_select_user";
  const ChatSelectUserScreen({Key? key}) : super(key: key);

  @override
  State<ChatSelectUserScreen> createState() => _ChatSelectUserScreenState();
}

class _ChatSelectUserScreenState extends State<ChatSelectUserScreen> {
  // move to list of users - to show avatar + full name
  List<Tuple<String, String>> _shownUsers = [];
  // is not optimized as well as the login username fetching
  // as all the users are fetched into app + it's definitely unsafe
  // cloud functions are required, which is paid
  void _checkNickname(String text, BuildContext context) async {
    final currentUsername = Provider.of<AuthProvider>(context, listen: false)
        .currentUserData.username;
    print(currentUsername);
    List<Tuple<String, String>> _currentSearchResults = [];
    if (text.isNotEmpty) {
      var firebaseSnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      final listOfUsers = firebaseSnapshot.docs
          .map((doc) => doc.data())
          .toList()
          .map((e) => e["username"])
          .toList();
      final listOfIds = firebaseSnapshot.docs.map((doc) => doc.id).toList();
      // non-optimized, probably
      for (var i = 0; i < listOfUsers.length; ++i) {
        if (listOfUsers[i].startsWith(text) && currentUsername != listOfUsers[i]) {
          _currentSearchResults.add(Tuple(listOfUsers[i], listOfIds[i]));
        }
      }
    }
    setState(() {
      _shownUsers = _currentSearchResults;
    });
  }

  void _goToChatWithPerson(String id) {
    print('pressed!');
    
    Navigator.of(context).popAndPushNamed(
      UserChatScreen.routeName,
      arguments: {'id': id},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: "Enter the user's nickname...",
            hintStyle: TextStyle(color: Colors.white),
          ),
          autofocus: true,
          onChanged: (text) => _checkNickname(text, context),
        ),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) => InkWell(
          onTap: () => _goToChatWithPerson(_shownUsers[index].second),
          child: SizedBox(
            height: 70,
            width: double.infinity,
            child: Container(
              color: Colors.grey.shade200,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_shownUsers[index].first),
              ),
            ),
          ),
        ),
        separatorBuilder: (context, index) => const Divider(),
        itemCount: _shownUsers.length,
      ),
    );
  }
}
