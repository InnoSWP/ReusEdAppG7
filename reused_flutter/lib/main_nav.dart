import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reused_flutter/providers/auth_provider.dart';
import 'package:reused_flutter/screens/chat/main_screen.dart';
import 'package:reused_flutter/screens/chat/select_user_screen.dart';
import 'package:reused_flutter/screens/dashboard/main_screen.dart';
import 'package:reused_flutter/screens/settings/main_screen.dart';
import 'package:reused_flutter/screens/social/main_screen.dart';
import 'package:reused_flutter/screens/forum/main_screen.dart';
import 'package:reused_flutter/screens/forum/new_discussion_screen.dart';
import 'package:reused_flutter/screens/profile/main_screen.dart';
import 'package:reused_flutter/screens/settings/main_screen.dart';
import 'package:reused_flutter/screens/shop/main_screen.dart';
import 'package:reused_flutter/widgets/app_drawer.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardMainScreen(),
    const ForumMainScreen(),
    const ChatsMainScreen(),
    const ShopMainScreen(),
    const ProfileMainScreen(),
  ];

  PreferredSizeWidget _getAppBar(BuildContext context, int _selectedIndex) {
    switch (_selectedIndex) {
      case 0:
        return AppBar(title: const Text("Dashboard"));
      case 1:
        return AppBar(title: const Text("Forum"));
      case 2:
        return AppBar(
          title: const Text("Chats"),
        );
      case 3:
        return AppBar(title: const Text("Shop"));
      case 4:
        return AppBar(
          title: const Text("Profile"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, SettingsMainScreen.routeName);
              },
              icon: const Icon(Icons.settings),
            ),
          ],
        );
      default:
        return AppBar(title: const Text("Dashboard"));
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false).initUserData();
    return Scaffold(
      appBar: _getAppBar(context, _selectedIndex),
      drawer: AppDrawer(),
      floatingActionButton: getFLoatingActionButton(_selectedIndex),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: 'Forum',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        showUnselectedLabels: false,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  getFLoatingActionButton(int selectedIndex) {
    return FloatingActionButton(
      onPressed: () {
        switch (selectedIndex) {
          case 1:
            Navigator.pushNamed(context, NewDiscussionScreen.routeName);
            break;
          case 2:
            Navigator.pushNamed(context, ChatSelectUserScreen.routeName);
            break;
        }
      },
      child: const Icon(Icons.add),
    );
  }
}
