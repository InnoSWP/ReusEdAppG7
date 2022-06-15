import 'package:flutter/material.dart';

class NewDiscussionScreen extends StatefulWidget {
  static const routeName = "/new_discussion";
  const NewDiscussionScreen({Key? key}) : super(key: key);

  @override
  State<NewDiscussionScreen> createState() => _NewDiscussionScreenState();
}

class _NewDiscussionScreenState extends State<NewDiscussionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New discussion"),
      ),
    );
  }
}
