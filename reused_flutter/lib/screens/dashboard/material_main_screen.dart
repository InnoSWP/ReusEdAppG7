import 'package:flutter/material.dart';
import 'package:reused_flutter/widgets/material/app_drawer.dart';

class MaterialDashboardMainScreen extends StatelessWidget {
  static const routeName = "/dashboard";
  const MaterialDashboardMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Dashboard"),
    );
  }
}
