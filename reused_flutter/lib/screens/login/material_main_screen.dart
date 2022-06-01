import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:reused_flutter/main.dart';

class MaterialLoginScreen extends StatefulWidget {
  const MaterialLoginScreen({Key? key}) : super(key: key);

  @override
  State<MaterialLoginScreen> createState() => _MaterialLoginScreenState();
}

class _MaterialLoginScreenState extends State<MaterialLoginScreen> {
  String dropdownValue = 'Teacher';
  bool _isLogIn = true;

  // void

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: mediaQuery.size.height / 6),
          const Text(
            'ReusEd',
            style: TextStyle(
              fontSize: 35,
            ),
          ),
          SizedBox(height: mediaQuery.size.height / 10),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (!_isLogIn)
                  TextFormField(
                    autocorrect: false,
                    enableSuggestions: false,
                    textCapitalization: TextCapitalization.none,
                    key: const ValueKey('username'),
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                TextFormField(
                  autocorrect: false,
                  enableSuggestions: false,
                  textCapitalization: TextCapitalization.none,
                  key: const ValueKey('email'),
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                  ),
                ),
                TextFormField(
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  textCapitalization: TextCapitalization.none,
                  key: const ValueKey('password'),
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                ),
                if (!_isLogIn)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('Role:'),
                      const SizedBox(width: 16),
                      DropdownButton<String>(
                        value: dropdownValue,
                        elevation: 16,
                        style: const TextStyle(color: Colors.blue),
                        underline: Container(
                          height: 2,
                          color: Colors.blue,
                        ),
                        items: <String>['Teacher', 'Student']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: const TextStyle(color: Colors.black)),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
          ElevatedButton(
            child: _isLogIn ? const Text("Log In") : const Text("Sign Up"),
            onPressed: () {},
          ),
          if (!_isLogIn)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogIn = true;
                      });
                    },
                    child: const Text("Log in")),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogIn = false;
                      });
                    },
                    child: const Text("Sign up")),
              ],
            ),
        ],
      ),
    );
  }
}
