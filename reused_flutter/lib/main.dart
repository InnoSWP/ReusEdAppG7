import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reused_flutter/main_nav.dart';

import 'packages/chats/providers/chat_provider.dart';
import 'packages/chats/screens/chat_screen.dart';
import 'packages/chats/screens/select_user_screen.dart';
import 'packages/forums/providers/discussion_provider.dart';
import 'packages/forums/screens/discussion_screen.dart';
import 'packages/forums/screens/main_screen.dart';
import 'packages/forums/screens/new_discussion_screen.dart';
import 'packages/main/providers/auth_provider.dart';
import 'packages/main/screens/create_course/main_screen.dart';
import 'packages/main/screens/dashboard/main_screen.dart';
import 'packages/main/screens/login/main_screen.dart';
import 'packages/main/screens/profile/main_screen.dart';
import 'packages/main/screens/settings/main_screen.dart';
import 'packages/shop/screens/item_screen.dart';
import 'packages/shop/screens/main_screen.dart';

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
        ChangeNotifierProvider<DiscussionProvider>(
          create: (_) => DiscussionProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ReusEd',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            accentColor: Colors.deepOrange.shade400,
            primarySwatch: Colors.indigo,
          ),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              return const MainNavigation();
            }
            return const LoginScreen();
          },
        ),
        routes: {
          DashboardMainScreen.routeName: (_) => const DashboardMainScreen(),
          ChatSelectUserScreen.routeName: (_) => const ChatSelectUserScreen(),
          ProfileMainScreen.routeName: (_) => const ProfileMainScreen(),
          SettingsMainScreen.routeName: (_) => const SettingsMainScreen(),
          ShopMainScreen.routeName: (_) => const ShopMainScreen(),
          ShopItemScreen.routeName: (_) => const ShopItemScreen(),
          CreateCourseMainScreen.routeName: (_) =>
              const CreateCourseMainScreen(),
          UserChatScreen.routeName: (_) => const UserChatScreen(),
          ForumMainScreen.routeName: (_) => const ForumMainScreen(),
          DiscussionScreen.routeName: (_) => const DiscussionScreen(),
          NewDiscussionScreen.routeName: (_) => const NewDiscussionScreen(),
        },
      ),
    );
  }
}
