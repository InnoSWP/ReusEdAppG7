import 'package:flutter/material.dart';
import 'package:reused_flutter/screens/dashboard/main_screen.dart';
import 'package:reused_flutter/screens/social/main_screen.dart';
import 'package:reused_flutter/screens/profile/main_screen.dart';
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
    const SocialMainScreen(),
    const ShopMainScreen(),
    const ProfileMainScreen(),
  ];

  bool _forumActive = true;

  PreferredSizeWidget _getAppBar(BuildContext context, int _selectedIndex) {
    switch (_selectedIndex) {
      case 0:
        return AppBar(title: const Text("Dashboard"));
      case 1:
        return AppBar(
          title: const Text("Social"),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  if (!_forumActive) _forumActive = true;
                });
              },
              child: Text("Forum",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _forumActive ? 18 : 16,
                    fontWeight: _forumActive ? FontWeight.bold : null,
                  )),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (_forumActive) _forumActive = false;
                });
              },
              child: Text("Leaderboard",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _forumActive ? 16 : 18,
                    fontWeight: _forumActive ? null : FontWeight.bold,
                  )),
            ),
          ],
        );
      case 2:
        return AppBar(title: const Text("Shop"));
      case 3:
        return AppBar(
          title: const Text("Profile"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
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
    return Scaffold(
      appBar: _getAppBar(context, _selectedIndex),
      drawer: AppDrawer(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Social',
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
}