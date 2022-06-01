import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reused_flutter/material_main.dart';
import 'package:reused_flutter/screens/dashboard/material_main_screen.dart';
import 'package:reused_flutter/screens/login/cupertino_main_screen.dart';
import 'package:reused_flutter/screens/login/material_main_screen.dart';
import 'package:reused_flutter/screens/social/material_main_screen.dart';
import 'package:reused_flutter/screens/profile/material_main_screen.dart';
import 'package:reused_flutter/screens/settings/material_main_screen.dart';
import 'package:reused_flutter/screens/shop/material_main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: 'ReusEd',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   routes: {
    //     '/': (_) => MaterialLoginScreen(),
    //     // '/': (_) => MaterialMainWidget(),
    //     MaterialDashboardMainScreen.routeName: (_) => MaterialDashboardMainScreen(),
    //     MaterialSocialMainScreen.routeName: (_) => MaterialSocialMainScreen(),
    //     MaterialProfileMainScreen.routeName: (_) => MaterialProfileMainScreen(),
    //     MaterialSettingsMainScreen.routeName: (_) => MaterialSettingsMainScreen(),
    //     MaterialShopMainScreen.routeName: (_) => MaterialShopMainScreen(),
    //   },
    // );
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'ReusEd',
      routes: {
        // '/': (_) => MaterialLoginScreen(),
        '/': (_) => CupertinoLoginScreen(),
        // '/': (_) => MaterialMainWidget(),
        MaterialDashboardMainScreen.routeName: (_) => MaterialDashboardMainScreen(),
        MaterialSocialMainScreen.routeName: (_) => MaterialSocialMainScreen(),
        MaterialProfileMainScreen.routeName: (_) => MaterialProfileMainScreen(),
        MaterialSettingsMainScreen.routeName: (_) => MaterialSettingsMainScreen(),
        MaterialShopMainScreen.routeName: (_) => MaterialShopMainScreen(),
      },
    );
  }
}