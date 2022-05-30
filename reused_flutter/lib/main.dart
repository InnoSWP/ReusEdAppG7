import 'package:flutter/material.dart';
import 'package:reused_flutter/material_main.dart';
import 'package:reused_flutter/screens/dashboard/material_main_screen.dart';
import 'package:reused_flutter/screens/social/material_main_screen.dart';
import 'package:reused_flutter/screens/profile/material_main_screen.dart';
import 'package:reused_flutter/screens/settings/material_main_screen.dart';
import 'package:reused_flutter/screens/shop/material_main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ReusEd',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      routes: {
        '/': (_) => MaterialMainWidget(),
        MaterialDashboardMainScreen.routeName: (_) => MaterialDashboardMainScreen(),
        MaterialSocialMainScreen.routeName: (_) => MaterialSocialMainScreen(),
        MaterialProfileMainScreen.routeName: (_) => MaterialProfileMainScreen(),
        MaterialSettingsMainScreen.routeName: (_) => MaterialSettingsMainScreen(),
        MaterialShopMainScreen.routeName: (_) => MaterialShopMainScreen(),
      },
    );
  }
}