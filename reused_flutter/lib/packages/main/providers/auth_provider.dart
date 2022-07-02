import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  late FirebaseAuth _currentUserAuthData;
  Map<String, dynamic> _currentUserData = {};
  final Map<String, UserModel> _usersDataByID = {};

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
    notifyListeners();
  }

  void reloadCurrentUserInfo() {
    _getCurrentUserInfo();
  }

  void initUserDataByID(String id) async {
    if (id == '') return;
    await FirebaseFirestore.instance.collection('users').doc(id).get().then(
      (value) {
        var userData = value.data()!;
        _usersDataByID[id] = UserModel(
          id: id,
          username: userData["username"],
          chats: userData["chats"],
          email: userData["email"],
          role: userData["role"],
        );
      },
    );
    notifyListeners();
  }

  UserModel getUserDataByID(String id) {
    if (!_usersDataByID.containsKey(id)) {
      initUserDataByID(id);
      return UserModel(
        id: '',
        username: 'Loading...',
        chats: {},
        email: '',
        role: '',
      );
    }
    return _usersDataByID[id]!;
  }

  FirebaseAuth get currentUserAuthData => _currentUserAuthData;
  UserModel get currentUserData {
    if (!_currentUserData.containsKey("username")) {
      return UserModel(
        id: '',
        username: 'Loading...',
        chats: {},
        email: '',
        role: '',
      );
    }
    return UserModel(
      id: _currentUserAuthData.currentUser!.uid,
      username: _currentUserData["username"],
      chats: _currentUserData["chats"] as Map<String, dynamic>,
      email: _currentUserData["email"],
      role: _currentUserData["role"],
    );
  }
}
