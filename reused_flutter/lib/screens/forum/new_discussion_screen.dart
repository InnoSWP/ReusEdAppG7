import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reused_flutter/providers/discussion_provider.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Discussion question/topic:',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Title",
                  ),
                  onChanged: (value) {
                    setState(() {
                      _discussionTitle = value;
                    });
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
              onPressed: _discussionTitle.isNotEmpty
                  ? (() {
                      discussionProvider.createNewDiscussion(_discussionTitle);
                      Navigator.pop(context);
                    })
                  : null,
              child: const Text("Create"),
            ),
          ],
        ),
      ),
    );
  }
}
