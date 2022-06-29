import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            title: const Text("Courses"),
            automaticallyImplyLeading: false,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Computer Science',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text("Data Structures"),
            onTap: () {
              // Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text("Mathematical Analysis"),
            onTap: () {
              // Navigator.of(context).pushReplacementNamed('/');
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
