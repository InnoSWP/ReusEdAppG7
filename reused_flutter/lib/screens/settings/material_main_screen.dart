import 'package:flutter/material.dart';

class MaterialSettingsMainScreen extends StatelessWidget {
  static const routeName = "/settings";
  const MaterialSettingsMainScreen({Key? key}) : super(key: key);

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
      body: const Center(
        child: Text("Settings"),
      ),
    );
  }
}
