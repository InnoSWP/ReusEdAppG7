import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text("Courses"),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text("Course 1"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          // const Divider(),
          // ListTile(
          //   leading: const Icon(Icons.payment),
          //   title: const Text("Orders"),
          //   onTap: () {
          //     Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
          //   },
          // ),
          // const Divider(),
          // ListTile(
          //   leading: const Icon(Icons.edit),
          //   title: const Text("Manage Products"),
          //   onTap: () {
          //     Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);
          //   },
          // ),
        ],
      ),
    );
  }
}
