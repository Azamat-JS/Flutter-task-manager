import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final Color color;
  final String headerText;
  final String description;

  const TaskCard({
    super.key,
    required this.color,
    required this.description,
    required this.headerText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color),
      child: Column(children: [Text(headerText), Text(description)]),
    );
  }
}
