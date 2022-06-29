import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main/models/user_model.dart';
import '../../main/providers/auth_provider.dart';
import 'chat_screen.dart';

class ChatSelectUserScreen extends StatefulWidget {
  static const routeName = "/chat_select_user";
  const ChatSelectUserScreen({Key? key}) : super(key: key);

  @override
  State<ChatSelectUserScreen> createState() => _ChatSelectUserScreenState();
}

class _ChatSelectUserScreenState extends State<ChatSelectUserScreen> {
  bool _noSearchResults = false;
  List<UserModel> _shownUsers = [];

  // TODO: optimize this
  void _checkNickname(
      String text, BuildContext context, AuthProvider provider) async {
    final currentUsername = provider.currentUserData.username;
    List<UserModel> currentSearchResults = [];
    if (text.isNotEmpty) {
      var firebaseSnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      final listOfUsers =
          firebaseSnapshot.docs.map((doc) => doc.data()["username"]).toList();
      final listOfIds = firebaseSnapshot.docs.map((doc) => doc.id).toList();
      for (var i = 0; i < listOfUsers.length; ++i) {
        if (listOfUsers[i].startsWith(text) &&
            currentUsername != listOfUsers[i]) {
          currentSearchResults.add(provider.getUserDataByID(listOfIds[i]));
        }
      }
      if (currentSearchResults.isEmpty) {
        setState(() {
          _noSearchResults = true;
        });
      }
    } else {
      setState(() {
        _noSearchResults = false;
      });
    }

    setState(() {
      _shownUsers = currentSearchResults;
    });
  }

  void _goToChatWithPerson(String id) {
    Navigator.of(context).popAndPushNamed(
      UserChatScreen.routeName,
      arguments: {'id': id},
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: "Enter the user's nickname...",
            hintStyle: TextStyle(color: Colors.white),
          ),
          autofocus: true,
          onChanged: (text) => _checkNickname(text, context, provider),
        ),
      ),
      body: (!_noSearchResults)
          ? ListView.builder(
              itemBuilder: (context, index) => InkWell(
                onTap: () => _goToChatWithPerson(_shownUsers[index].id),
                child: SearchResultCard(_shownUsers[index]),
              ),
              itemCount: _shownUsers.length,
            )
          : const Center(
              child: Text("Nothing was found."),
            ),
    );
  }
}

class SearchResultCard extends StatelessWidget {
  final UserModel userData;
  const SearchResultCard(this.userData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
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
                          userData.username,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          userData.role,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
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
