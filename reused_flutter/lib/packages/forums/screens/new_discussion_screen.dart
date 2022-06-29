import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/discussion_provider.dart';

class NewDiscussionScreen extends StatefulWidget {
  static const routeName = "/new_discussion";
  const NewDiscussionScreen({Key? key}) : super(key: key);

  @override
  State<NewDiscussionScreen> createState() => _NewDiscussionScreenState();
}

class _NewDiscussionScreenState extends State<NewDiscussionScreen> {
  String _discussionTitle = '';

  @override
  Widget build(BuildContext context) {
    final discussionProvider = Provider.of<DiscussionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("New discussion"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Discussion question/topic:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Form(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Topic title",
                    ),
                    onChanged: (value) {
                      _discussionTitle = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Title should not be empty';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  discussionProvider.createNewDiscussion(_discussionTitle);
                  Navigator.pop(context);
                },
                child: const Text("Create"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
