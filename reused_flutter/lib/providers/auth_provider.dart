import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  late FirebaseAuth _currentUserAuthData;
  Map<String, dynamic> _currentUserData = {};

  AuthProvider();

  void initUserData() {
    _currentUserAuthData = FirebaseAuth.instance;
    _getCurrentUserInfo();
  }

  void _getCurrentUserInfo() async {
    var user = FirebaseAuth.instance;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.currentUser!.uid)
        .get()
        .then((value) => _currentUserData = value.data()!);
  }

  FirebaseAuth get currentUserAuthData => _currentUserAuthData;
  Map<String, dynamic> get currentUserData => _currentUserData;
}
