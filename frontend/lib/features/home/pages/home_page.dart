import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/constants/utils.dart';
import 'package:frontend/features/home/widgets/task_card.dart';

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
          Row(
            children: [
              Expanded(
                child: TaskCard(
                  color: const Color.fromRGBO(246, 222, 194, 1),
                  description:
                      'This is a new task of mine where i will do it later and check it again when i completed it, or just remove it if i dont want to see this task again apart from that i will create the same task again if it is needed',
                  headerText: 'New task',
                ),
              ),
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('10:00AM', style: TextStyle(fontSize: 17)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
