import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DashboardMainScreen extends StatefulWidget {
  static const routeName = "/dashboard";

  const DashboardMainScreen({Key? key}) : super(key: key);

  @override
  State<DashboardMainScreen> createState() => _DashboardMainScreenState();
}

class _DashboardMainScreenState extends State<DashboardMainScreen> {
  void initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  @override
  void initState() {
    super.initState();
    initFirebase();
  }

  final CollectionReference _courses =
      FirebaseFirestore.instance.collection('courses');

  @override
  Widget build(BuildContext context) {
    // return Center(
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       ElevatedButton(
    //         onPressed: () => Navigator.of(context).pushNamed('/create_course'),
    //         child: const Text("Create course"),
    //       ),
    //     ],
    //   ),
    // );
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Text(
            //   'Your courses',
            //   style: TextStyle(
            //       color: Colors.black,
            //       fontSize: 32,
            //       fontWeight: FontWeight.bold),
            // ),
            StreamBuilder(
              stream: _courses.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return Flexible(
                    child: ListView.builder(
                      shrinkWrap: false,
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      itemCount:
                          streamSnapshot.data!.docs.length, //number of rows
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot =
                            streamSnapshot.data!.docs[index];
                        return Card(
                          margin: const EdgeInsets.all(10),
                          child: SizedBox(
                            width: 150,
                            child: ListTile(
                              leading: const Icon(Icons.computer),
                              title: Text(
                                documentSnapshot['course']['coursename'],
                                maxLines: 2,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: (){showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildPopupDialog(context),
                              );},
                              subtitle: Text(
                                documentSnapshot['course']['description'],
                                maxLines: 2,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
Widget _buildPopupDialog(BuildContext context) {
  return AlertDialog(
    title: const Text('Coursename'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text("Description"),
      ],
    ),
    actions: <Widget>[
      MaterialButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Close'),
      ),
    ],
  );
}