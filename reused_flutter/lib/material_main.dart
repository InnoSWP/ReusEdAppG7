import 'package:flutter/material.dart';
import 'package:reused_flutter/screens/dashboard/material_main_screen.dart';
import 'package:reused_flutter/screens/social/material_main_screen.dart';
import 'package:reused_flutter/screens/profile/material_main_screen.dart';
import 'package:reused_flutter/screens/shop/material_main_screen.dart';
import 'package:reused_flutter/widgets/material/app_drawer.dart';

class MaterialMainWidget extends StatefulWidget {
  const MaterialMainWidget({Key? key}) : super(key: key);

  @override
  State<MaterialMainWidget> createState() => _MaterialMainWidgetState();
}

class _MaterialMainWidgetState extends State<MaterialMainWidget> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    MaterialDashboardMainScreen(),
    MaterialSocialMainScreen(),
    MaterialShopMainScreen(),
    MaterialProfileMainScreen(),
  ];

  PreferredSizeWidget _getAppBar(BuildContext context, int _selectedIndex) {
    switch (_selectedIndex) {
      case 0:
        return AppBar(title: const Text("Dashboard"));
      case 1:
        return AppBar(title: const Text("Social"));
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
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
