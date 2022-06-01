import 'package:flutter/material.dart';

class MaterialDashboardMainScreen extends StatelessWidget {
  static const routeName = "/dashboard";
  const MaterialDashboardMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          MaterialButton(
            onPressed: () {},
            child: Text("Create course"),
          ),
          Text("either create course from a for")
        ],
      ),
    );
  }
}
