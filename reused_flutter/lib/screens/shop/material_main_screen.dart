import 'package:flutter/material.dart';

class MaterialShopMainScreen extends StatelessWidget {
  static const routeName = "/shop";
  const MaterialShopMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Shop"),
    );
  }
}
