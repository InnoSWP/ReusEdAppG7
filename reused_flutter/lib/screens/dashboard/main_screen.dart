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
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Your courses',
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),

            StreamBuilder(
              stream: _courses.snapshots(), //build connection
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: streamSnapshot.data!.docs.length,  //number of rows
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: SizedBox(width: 150,child: ListTile(
                          title: Text(documentSnapshot['course']['coursename']),
                          subtitle: Text(documentSnapshot['course']['description']),
                        ),),
                      );
                    },
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            )

          ],
        ),
      )

    );
  }
}
