import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'packages.dart';
import 'packages/chats/screens/main_screen.dart';
import 'packages/chats/screens/select_user_screen.dart';
import 'packages/forums/screens/main_screen.dart';
import 'packages/forums/screens/new_discussion_screen.dart';
import 'packages/main/providers/auth_provider.dart';
import 'packages/main/screens/dashboard/main_screen.dart';
import 'packages/main/screens/profile/main_screen.dart';
import 'packages/main/screens/settings/main_screen.dart';
import 'packages/main/widgets/app_drawer.dart';
import 'packages/shop/screens/main_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  String _currentSelected = 'Main';

  PreferredSizeWidget _getAppBar(BuildContext context, String selected) {
    final userData = Provider.of<AuthProvider>(context).currentUserData;
    switch (selected) {
      case 'Main':
        return AppBar(title: const Text("Dashboard"));
      case 'Forums':
        return AppBar(title: const Text("Forum"));
      case 'Chats':
        return AppBar(
          title: const Text("Chats"),
        );
      case 'Shop':
        return AppBar(title: const Text("Shop"));
      case 'Profile':
        return AppBar(
          title: Text(userData.username),
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
    if (!importedPackages.contains('Main')) {
      throw Exception('The app can\'t work without the main screen.');
    }
    final List<Widget> screens = [
      for (var package in importedPackages)
        if (package == 'Main')
          const DashboardMainScreen()
        else if (package == 'Forums')
          const ForumMainScreen()
        else if (package == 'Chats')
          const ChatsMainScreen()
        else if (package == 'Shop')
          const ShopMainScreen()
        else if (package == 'Profile')
          const ProfileMainScreen()
        else
          const DashboardMainScreen()
    ];
    Provider.of<AuthProvider>(context, listen: false).initUserData();
    return Scaffold(
      appBar: _getAppBar(context, _currentSelected),
      drawer: AppDrawer(),
      floatingActionButton: getFLoatingActionButton(_currentSelected),
      body: screens[_selectedIndex],
      bottomNavigationBar: (importedPackages.length > 1)
          ? BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: <BottomNavigationBarItem>[
                for (var item in importedPackages)
                  if (item == 'Main')
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Dashboard',
                    )
                  else if (item == 'Forums')
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.forum),
                      label: 'Forum',
                    )
                  else if (item == 'Chats')
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.chat),
                      label: 'Chat',
                    )
                  else if (item == 'Shop')
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.shopping_cart),
                      label: 'Shop',
                    )
                  else if (item == 'Profile')
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: 'Profile',
                    )
                  else
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Dashboard',
                    )
              ],
              currentIndex: _selectedIndex,
              showUnselectedLabels: false,
              onTap: (index) {
                setState(() {
                  _currentSelected = importedPackages[index];
                  _selectedIndex = index;
                });
              },
            )
          : null,
    );
  }

  getFLoatingActionButton(String selected) {
    return (selected == 'Chats' || selected == 'Forums')
        ? FloatingActionButton(
            onPressed: () {
              switch (selected) {
                case 'Forums':
                  Navigator.pushNamed(context, NewDiscussionScreen.routeName);
                  break;
                case 'Chats':
                  Navigator.pushNamed(context, ChatSelectUserScreen.routeName);
                  break;
              }
            },
            child: const Icon(Icons.add),
          )
        : null;
  }
}
