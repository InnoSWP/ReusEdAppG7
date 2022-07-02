import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileMainScreen extends StatelessWidget {
  static const routeName = "/profile";
  const ProfileMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => FirebaseAuth.instance.signOut(),
        child: const Text("Log out"),
      ),
    );
  }
}
