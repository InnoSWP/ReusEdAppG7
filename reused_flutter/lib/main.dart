import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reused_flutter/main_nav.dart';
import 'package:reused_flutter/providers/auth_provider.dart';
import 'package:reused_flutter/providers/chat_provider.dart';
import 'package:reused_flutter/screens/chat/chat_screen.dart';
import 'package:reused_flutter/screens/chat/select_user_screen.dart';
import 'package:reused_flutter/screens/create_course/main_screen.dart';
import 'package:reused_flutter/screens/dashboard/main_screen.dart';
import 'package:reused_flutter/screens/login/main_screen.dart';
import 'package:reused_flutter/screens/profile/main_screen.dart';
import 'package:reused_flutter/screens/settings/main_screen.dart';
import 'package:reused_flutter/screens/shop/item_screen.dart';
import 'package:reused_flutter/screens/shop/main_screen.dart';

import 'screens/splash/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<ChatProvider>(
          create: (_) => ChatProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ReusEd',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }
            if (snapshot.hasData) {
              return const MainNavigation();
            }
            return const LoginScreen();
          },
        ),
        routes: {
          DashboardMainScreen.routeName: (_) => const DashboardMainScreen(),
          ChatSelectUserScreen.routeName: (_) => const ChatSelectUserScreen(),
          // SocialMainScreen.routeName: (_) => const SocialMainScreen(),
          ProfileMainScreen.routeName: (_) => const ProfileMainScreen(),
          SettingsMainScreen.routeName: (_) => const SettingsMainScreen(),
          ShopMainScreen.routeName: (_) => const ShopMainScreen(),
          ShopItemScreen.routeName: (_) => const ShopItemScreen(),
          CreateCourseMainScreen.routeName: (_) =>
              const CreateCourseMainScreen(),
          UserChatScreen.routeName: (_) => const UserChatScreen(),
        },
      ),
    );
  }
}
