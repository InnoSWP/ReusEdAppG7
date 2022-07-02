import 'package:flutter/material.dart';

class CreateCourseMainScreen extends StatefulWidget {
  static const routeName = '/create_course';
  const CreateCourseMainScreen({Key? key}) : super(key: key);

  @override
  State<CreateCourseMainScreen> createState() => _CreateCourseMainScreenState();
}

class _CreateCourseMainScreenState extends State<CreateCourseMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Course"),
      ),
      body: const Center(
        child: Text("Create"),
      ),
    );
  }
}
