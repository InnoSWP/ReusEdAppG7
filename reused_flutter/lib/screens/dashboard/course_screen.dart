import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class CourseScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Here you can see your coursename"),
        leading: BackButton(),
      ),
      body: Flexible(child: Container(
        color: Colors.pink,
      ),),
    );
  }
}