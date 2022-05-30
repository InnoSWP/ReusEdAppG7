import 'package:flutter/material.dart';

class MaterialProfileMainScreen extends StatelessWidget {
  static const routeName = "/profile";
  const MaterialProfileMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Profile"),
    );
  }
}