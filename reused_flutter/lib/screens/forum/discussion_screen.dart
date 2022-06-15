import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reused_flutter/providers/auth_provider.dart';

class DiscussionScreen extends StatefulWidget {
  static const routeName = "/discussion";
  const DiscussionScreen({Key? key}) : super(key: key);

  @override
  State<DiscussionScreen> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen> {
  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;
    final documentSnapshot = routeArgs["document"];
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: SizedBox(
              width: double.infinity,
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                title: Text(
                  documentSnapshot["title"],
                  maxLines: 2,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                    authProvider
                        .getUserDataByID(documentSnapshot["author"])
                        .username,
                    style: const TextStyle(
                      fontSize: 18,
                    )),
              ),
            ),
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('discussions')
                .doc(documentSnapshot.id)
                .snapshots(),
            builder: (context, discussionSnapshot) {
              if (!discussionSnapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              var discussionData =
                  discussionSnapshot.data!.data() as Map<String, dynamic>;

              return Flexible(
                child: ListView.builder(
                  itemCount: discussionData["comments"].length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: SizedBox(
                        width: double.infinity,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          title: Text(
                            discussionData["comments"][index]["comment"],
                            maxLines: 2,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            authProvider
                                .getUserDataByID(
                                    discussionData["comments"][index]["sender"])
                                .username,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Expanded(
                  child: InkWell(
                    onTap: null,
                    child: TextField(
                      decoration: InputDecoration.collapsed(
                        hintText: 'Enter your comment...',
                        focusColor: null,
                        filled: false,
                      ),
                      maxLines: 10,
                      minLines: 1,
                      autofocus: true,
                      keyboardType: TextInputType.multiline,
                      onChanged: null,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Send"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}