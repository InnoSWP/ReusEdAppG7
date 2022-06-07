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
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('courses').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Text('No courses added');
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Text(
                  "No courses added by far"); // return the widget you want as "header" here
            }
            return ListTile(
              title: Text(snapshot.data!.docs[index]['coursename']),
              subtitle: Text(snapshot.data!.docs[index]['description']),
            );
          },
        );
      },
    );
  }
}
