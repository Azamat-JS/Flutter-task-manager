import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => const HomePage());
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.add))],
      ),
      body: Column(
        children: [
          /// date selector
        ],
      ),
    );
  }
}
