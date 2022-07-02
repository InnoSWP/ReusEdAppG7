import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reused_flutter/screens/shop/item_screen.dart';

class ShopMainScreen extends StatelessWidget {
  static const routeName = "/shop";
  const ShopMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('shop').get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        var data = snapshot.data!.docs.map((doc) => doc).toList();
        return ListView.builder(
          itemBuilder: (context, index) {
            return ShopCard(data[index].id, data[index]["name"],
                data[index]["description"]);
          },
          itemCount: data.length,
        );
      },
    );
  }
}

class ShopCard extends StatelessWidget {
  final String cardName;
  final String id;
  final String imageSource;

  const ShopCard(this.id, this.cardName, this.imageSource, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: InkWell(
          onTap: () => Navigator.of(context).pushNamed(
            ShopItemScreen.routeName,
            arguments: {"id": id},
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cardName,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '10.00\$',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600)
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text("Buy"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}