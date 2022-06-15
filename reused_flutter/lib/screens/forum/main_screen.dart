import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reused_flutter/models/tuple.dart';
import 'package:reused_flutter/providers/auth_provider.dart';
import 'package:reused_flutter/providers/discussion_provider.dart';
import 'package:reused_flutter/screens/forum/discussion_screen.dart';

class ForumMainScreen extends StatefulWidget {
  static const routeName = "/forum";
  const ForumMainScreen({Key? key}) : super(key: key);

  @override
  State<ForumMainScreen> createState() => _ForumMainScreenState();
}

class _ForumMainScreenState extends State<ForumMainScreen> {
  @override
  Widget build(BuildContext context) {
    final CollectionReference forums =
        FirebaseFirestore.instance.collection('discussions');
    final authProvider = Provider.of<AuthProvider>(context);
    final discussionProvider = Provider.of<DiscussionProvider>(context);

    return StreamBuilder(
      stream: forums.snapshots(),
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot> streamSnapshot,
      ) {
        if (!streamSnapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        var discussionsList = streamSnapshot.data!.docs;
        discussionsList.sort(
          (a, b) {
            return b["creationTime"].compareTo(a["creationTime"]);
          },
        );

        return ListView.builder(
          itemCount: streamSnapshot.data!.docs.length,
          itemBuilder: (
            BuildContext context,
            int index,
          ) {
            return ForumCard(discussionsList[index]);
          },
        );
      },
    );
  }
}

class ForumCard extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;

  const ForumCard(this.documentSnapshot, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final senderUsername = Provider.of<AuthProvider>(context)
        .getUserDataByID(documentSnapshot["author"])
        .username;

    return Card(
      margin: const EdgeInsets.all(10),
      child: SizedBox(
        width: double.infinity,
        child: ListTile(
          contentPadding: const EdgeInsets.all(10),
          title: Text(
            documentSnapshot['title'],
            maxLines: 2,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            senderUsername,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          trailing: const Icon(
            Icons.keyboard_arrow_right_outlined,
          ),
          onTap: () => Navigator.of(context).pushNamed(
            DiscussionScreen.routeName,
            arguments: {'document': documentSnapshot},
          ),
        ),
      ),
    );
  }
}
