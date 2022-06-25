import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShopItemScreen extends StatelessWidget {
  static const routeName = "/shopitem";
  const ShopItemScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String itemId = routeArgs['id']!;
    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder<DocumentSnapshot>(
            future:
                FirebaseFirestore.instance.collection('shop').doc(itemId).get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              var data = snapshot.data!;
              return Column(
                children: [
                  Text('Description: ${data["description"]}'),
                ],
              );
            }));
  }
}
