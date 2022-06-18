import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reused_flutter/providers/auth_provider.dart';

class ChatsMainScreen extends StatelessWidget {
  static const routeName = "/chats";
  const ChatsMainScreen({Key? key}) : super(key: key);

  void _allUsers() async {
    var _allUsers = await FirebaseFirestore.instance.collection('users').get();
    // if (_allUsers.docs.contains(username)) {
    //   print('hello');
    // }
    print('???');
    print(_allUsers.docs.map(
      (e) => e.id
    ));
  }

  @override
  Widget build(BuildContext context) {
    final _userData =
        Provider.of<AuthProvider>(context).getAuthInfo().currentUser;
    // _allUsers();
    // print(_userData.)
    return ElevatedButton(
      onPressed: () {},
      child: const Text("Create chat"),
    );
  }
}

class ChatCard extends StatelessWidget {
  const ChatCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(_userData.currentUser!.uid);
    return Container();
  }
}
