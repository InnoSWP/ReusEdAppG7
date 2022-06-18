import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider();

  FirebaseAuth getAuthInfo() {
    var user = FirebaseAuth.instance;
    return user;
  }
}
