import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void _submitAuth(
    String email,
    String password,
    String username,
    String role,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential userCredentials;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        userCredentials = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        // it is definitely not the best solution
        // if the user base is enormous, then the app performance will suck
        var firebaseSnapshot =
            await FirebaseFirestore.instance.collection('users').get();
        final listOfUsers = firebaseSnapshot.docs
            .map((doc) => doc.data())
            .toList()
            .map((e) => e["username"])
            .toList();
        if (listOfUsers.contains(username)) {
          setState(() {
            _isLoading = false;
            ScaffoldMessenger.of(ctx).showSnackBar(
              const SnackBar(
                content: Text("This username is already taken."),
              ),
            );
          });
          return;
        }
        userCredentials = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set(
          {
            'username': username,
            'email': email,
            'role': role,
            'chats': {},
          },
        );
      }
    } on FirebaseAuthException catch (error) {
      String message = 'An error occurred, please check your credentials.';

      if (error.message != null) {
        message = error.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    } catch (error) {
      rethrow;
    }
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: AuthForm(_submitAuth, _isLoading),
    );
  }
}
