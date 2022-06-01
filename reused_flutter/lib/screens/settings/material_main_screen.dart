import 'package:flutter/material.dart';

class MaterialSettingsMainScreen extends StatefulWidget {
  static const routeName = "/settings";
  const MaterialSettingsMainScreen({Key? key}) : super(key: key);

  @override
  State<MaterialSettingsMainScreen> createState() =>
      _MaterialSettingsMainScreenState();
}

class _MaterialSettingsMainScreenState
    extends State<MaterialSettingsMainScreen> {

  void _submitChangedPassword() {
    // firebase code here
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        leading: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Change Password", style: TextStyle(fontSize: 25)),
            TextFormField(
              obscureText: true,
              key: const ValueKey('password'),
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            TextFormField(
              obscureText: true,
              key: const ValueKey('password_confirm'),
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
              ),
            ),
            ElevatedButton(
              onPressed: _submitChangedPassword,
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
