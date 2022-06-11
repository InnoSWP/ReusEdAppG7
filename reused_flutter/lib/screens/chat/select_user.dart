import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reused_flutter/providers/auth_provider.dart';

class ChatSelectUserScreen extends StatefulWidget {
  static const routeName = "/chat_select_user";
  const ChatSelectUserScreen({Key? key}) : super(key: key);

  @override
  State<ChatSelectUserScreen> createState() => _ChatSelectUserScreenState();
}

class _ChatSelectUserScreenState extends State<ChatSelectUserScreen> {
  // move to list of users - to show avatar + full name
  List<String> _shownUsers = [];
  // is not optimized as well as the login username fetching
  // as all the users are fetched into app + it's definitely unsafe
  // cloud functions are required, which is paid
  void _checkNickname(String text, String currentUsername) async {
    print(currentUsername);
    List<String> _currentSearchResults = [];
    if (text.isNotEmpty) {
      var firebaseSnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      final listOfUsers = firebaseSnapshot.docs
          .map((doc) => doc.data())
          .toList()
          .map((e) => e["username"])
          .toList();
      // non-optimized, probably
      for (var user in listOfUsers) {
        if (user.startsWith(text) && currentUsername != user) {
          _currentSearchResults.add(user);
        }
      }
    }
    setState(() {
      _shownUsers = _currentSearchResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _userData =
        Provider.of<AuthProvider>(context).getAuthInfo().currentUser;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: "Enter the user's nickname...",
            hintStyle: TextStyle(color: Colors.white),
          ),
          autofocus: true,
          onChanged: (text) => _checkNickname(text, _userData!.uid),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => Text(_shownUsers[index]),
        itemCount: _shownUsers.length,
      ),
    );
  }
}
