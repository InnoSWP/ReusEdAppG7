import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ForumMainScreen extends StatefulWidget {
  static const routeName = "/forum";

  const ForumMainScreen({Key? key}) : super(key: key);

  @override
  State<ForumMainScreen> createState() => _ForumMainScreenState();
}

class _ForumMainScreenState extends State<ForumMainScreen> {
  void initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  @override
  void initState() {
    super.initState();
    initFirebase();
  }

  final CollectionReference _forums =
      FirebaseFirestore.instance.collection('forums');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              StreamBuilder(
                stream: _forums.snapshots(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<QuerySnapshot> streamSnapshot,
                ) {
                  if (streamSnapshot.hasData) {
                    return Flexible(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (
                          BuildContext context,
                          int index,
                        ) {
                          final DocumentSnapshot documentSnapshot =
                              streamSnapshot.data!.docs[index];

                          return ForumCard(documentSnapshot);
                        },
                      ),
                    );
                  }

                  // If snapshot has no data.
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ]),
      ),
    );
  }
}

class ForumCard extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;

  const ForumCard(this.documentSnapshot, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: SizedBox(
        width: 150,
        child: ListTile(
          contentPadding: const EdgeInsets.all(10),
          title: Text(
            documentSnapshot['title'],
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: const Icon(
            Icons.keyboard_arrow_right_outlined,
          ),
          onTap: () {},
        ),
      ),
    );
  }
}
