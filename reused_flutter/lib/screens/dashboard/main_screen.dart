import 'package:flutter/material.dart';

class DashboardMainScreen extends StatelessWidget {
  static const routeName = "/dashboard";
  const DashboardMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pushNamed('/create_course'),
            child: const Text("Create course"),
          ),
        ],
      ),
    );
  }
}
